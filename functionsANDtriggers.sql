CREATE OR REPLACE FUNCTION public.get_user_orders(p_user_id uuid)
RETURNS TABLE (
    order_id integer,
    ordered_at timestamp without time zone,
    total_price numeric,
    status character varying,
    order_items jsonb,
    feedback_details jsonb
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.order_id, 
        o.ordered_at, 
        o.total_price,
        o.status,
        (
            SELECT jsonb_agg(jsonb_build_object(
                'product_id', oi.product_id,
                'quantity', oi.quantity,
                'price', oi.price,
                'product_name', p.product_name,
                'image_url', p.image_url
            ))
            FROM public.hasorderitems oi
            JOIN public.products p ON oi.product_id = p.product_id
            WHERE oi.order_id = o.order_id
        ) AS order_items,
        (
            SELECT jsonb_agg(jsonb_build_object(
                'feedback_id', gf.feedback_id,
                'rating', gf.rating,
                'comment', gf.comment
            ))
            FROM public.givesfeedback gf
            WHERE gf.order_id = o.order_id AND gf.user_id = p_user_id
        ) AS feedback_details
    FROM public.orders o
    WHERE o.user_id = p_user_id
    ORDER BY o.ordered_at DESC;
END;
$$ LANGUAGE plpgsql;




------------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
DECLARE
  v_name TEXT;
BEGIN
  v_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'user_name',
    SPLIT_PART(NEW.email, '@', 1)
  );

  INSERT INTO public.users (id, name)
  VALUES (
    NEW.id,
    v_name
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.process_order1(
  p_user_id uuid,
  p_cart_items json
)
RETURNS integer AS $$
DECLARE
  new_order_id int4;
  total_order_price numeric := 0;
  cart_item_data jsonb;
  product_record record;
  product_quantity_available int4;
  user_cart_id_for_cleanup int4;
BEGIN
  IF p_cart_items IS NULL OR jsonb_array_length(p_cart_items::jsonb) = 0 THEN
    RAISE EXCEPTION 'INPUT_ERROR: Cannot place order with an empty cart.';
  END IF;

  FOR cart_item_data IN SELECT * FROM jsonb_array_elements(p_cart_items::jsonb)
  LOOP
    IF (cart_item_data->>'product_id') IS NULL THEN
      RAISE EXCEPTION 'INPUT_ERROR: Product ID is missing in one of the cart items.';
    END IF;
    IF (cart_item_data->>'quantity') IS NULL OR (cart_item_data->>'quantity')::int4 <= 0 THEN
      RAISE EXCEPTION 'INPUT_ERROR: Invalid quantity for product ID %. Must be positive.', cart_item_data->>'product_id';
    END IF;
    IF (cart_item_data->>'price') IS NULL OR (cart_item_data->>'price')::numeric < 0 THEN
      RAISE EXCEPTION 'INPUT_ERROR: Invalid price for product ID %. Cannot be negative.', cart_item_data->>'product_id';
    END IF;

    total_order_price := total_order_price + (
      (cart_item_data->>'quantity')::int4 * (cart_item_data->>'price')::numeric
    );
  END LOOP;

  FOR cart_item_data IN SELECT * FROM jsonb_array_elements(p_cart_items::jsonb)
  LOOP
    SELECT quantity INTO product_quantity_available
    FROM public.products
    WHERE product_id = (cart_item_data->>'product_id')::int4;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'PRODUCT_NOT_FOUND: Product with ID % not found.', cart_item_data->>'product_id';
    END IF;

    IF product_quantity_available IS NULL OR product_quantity_available < (cart_item_data->>'quantity')::int4 THEN
      SELECT product_name INTO product_record
      FROM public.products
      WHERE product_id = (cart_item_data->>'product_id')::int4;

      RAISE EXCEPTION 'INSUFFICIENT_STOCK: Product % (ID: %) - Available: %, Requested: %',
        COALESCE(product_record.product_name, 'Unknown Product'),
        cart_item_data->>'product_id',
        COALESCE(product_quantity_available, 0),
        cart_item_data->>'quantity';
    END IF;
  END LOOP;

  INSERT INTO public.orders (user_id, total_price, status)
  VALUES (p_user_id, total_order_price, 'Processing')
  RETURNING order_id INTO new_order_id;

  FOR cart_item_data IN SELECT * FROM jsonb_array_elements(p_cart_items::jsonb)
  LOOP
    INSERT INTO public.hasorderitems (order_id, product_id, quantity, price)
    VALUES (
      new_order_id,
      (cart_item_data->>'product_id')::int4,
      (cart_item_data->>'quantity')::int4,
      (cart_item_data->>'price')::numeric
    );
  END LOOP;

  SELECT c.cart_id INTO user_cart_id_for_cleanup 
  FROM public.cart c 
  WHERE c.user_id = p_user_id 
  LIMIT 1;

  IF user_cart_id_for_cleanup IS NOT NULL THEN
    DELETE FROM public.cart_items ci WHERE ci.cart_id = user_cart_id_for_cleanup;
    UPDATE public.orders o SET cart_id = user_cart_id_for_cleanup WHERE o.order_id = new_order_id;
  END IF;

  RETURN new_order_id;

EXCEPTION 
  WHEN OTHERS THEN
    RAISE WARNING '[PROCESS_ORDER_ERROR] UserID: %, Error: %, SQLState: %', p_user_id, SQLERRM, SQLSTATE;
    RAISE;
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.reduce_stock()
RETURNS trigger AS $$
BEGIN
  UPDATE products
  SET quantity = quantity - NEW.quantity
  WHERE product_id = NEW.product_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------

