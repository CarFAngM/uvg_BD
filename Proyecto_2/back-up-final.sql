PGDMP      6            	    |         
   proyecto_2    16.3    16.3 p    p           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            r           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            s           1262    17876 
   proyecto_2    DATABASE     �   CREATE DATABASE proyecto_2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Guatemala.1252';
    DROP DATABASE proyecto_2;
                postgres    false                        2615    18143    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            t           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                   postgres    false    5            u           0    0    SCHEMA public    ACL     +   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
                   postgres    false    5            �            1255    18493    actualizar_insumos()    FUNCTION     U  CREATE FUNCTION public.actualizar_insumos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    insumo_record RECORD;
    nueva_cantidad INTEGER;
BEGIN

    FOR insumo_record IN (SELECT i.insumo_id, i.cantidad_disponible
                          FROM Insumo i
                          JOIN Insumo_Plato ip ON i.insumo_id = ip.insumo_id
                          WHERE ip.plato_id = NEW.plato_id)
    LOOP
        -- Calculamos la nueva cantidad disponible
        nueva_cantidad := insumo_record.cantidad_disponible - 1;

        -- Actualizamos la cantidad disponible en la tabla Insumo
        UPDATE Insumo
        SET cantidad_disponible = nueva_cantidad
        WHERE insumo_id = insumo_record.insumo_id;

        -- Verificamos si la nueva cantidad es menor que 16
        IF nueva_cantidad < 16 THEN
            UPDATE Insumo
            SET alerta_stock_bajo = TRUE
            WHERE insumo_id = insumo_record.insumo_id;

            RAISE NOTICE 'Alerta: El insumo % está por debajo de 16 unidades de stock', insumo_record.insumo_id;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.actualizar_insumos();
       public          postgres    false    5            �            1255    18327    bloquear_mesa_por_pedido()    FUNCTION     �  CREATE FUNCTION public.bloquear_mesa_por_pedido() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    accion_personalizada TEXT;
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id;

	if NEW.mesa_id is not null then 
	accion_personalizada := 'Mesa bloqueada por pedido: ' || NEW.pedido_id || ', Mesa ID: ' || NEW.mesa_id;
    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');
	else 
		accion_personalizada:= 'Se realizo el pedido' || NEW.pedido_id || 'a domicilio';
		INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    	VALUES (accion_personalizada, now(), 'pedido');
	end if; 
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.bloquear_mesa_por_pedido();
       public          postgres    false    5            �            1255    18323    bloquear_mesa_por_reserva()    FUNCTION     C  CREATE FUNCTION public.bloquear_mesa_por_reserva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id AND NEW.estado = 'VIGENTE';


    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;

    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.bloquear_mesa_por_reserva();
       public          postgres    false    5            �            1255    18325 #   desbloquear_mesa_por_finalizacion()    FUNCTION     T  CREATE FUNCTION public.desbloquear_mesa_por_finalizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    accion_personalizada TEXT; 
BEGIN
    -- Verifica si el estado de la reserva cambió a 'FINALIZADA'
    IF NEW.estado = 'FINALIZADA' THEN
    UPDATE mesa
    SET disponibilidad = TRUE
    WHERE mesa.mesa_id = NEW.mesa_id;

    accion_personalizada := 'Mesa desbloqueada por finalización de reserva: ' || NEW.mesa_id;
    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');
	END IF;
    
    RETURN NEW; 
END;
$$;
 :   DROP FUNCTION public.desbloquear_mesa_por_finalizacion();
       public          postgres    false    5            �            1255    18500    desbloquear_mesa_por_pedido()    FUNCTION     q  CREATE FUNCTION public.desbloquear_mesa_por_pedido() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    accion_personalizada TEXT;
BEGIN

    accion_personalizada := 'Mesa desbloqueada, Mesa ID: ' || NEW.mesa_id;


    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');

    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.desbloquear_mesa_por_pedido();
       public          postgres    false    5            �            1255    18502 (   insertar_bitacora_finalizacion_reserva()    FUNCTION     �  CREATE FUNCTION public.insertar_bitacora_finalizacion_reserva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
accion_personalizada text;
BEGIN
	if new.estado = 'FINALIZADA' then 
	accion_personalizada := 'Reserva finalizada: ' || new.reserva_id;
	INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
	VALUES (accion_personalizada, now(), 'reserva'); 
    END IF;
RETURN new;
END;
$$;
 ?   DROP FUNCTION public.insertar_bitacora_finalizacion_reserva();
       public          postgres    false    5            �            1259    18154    bitacora    TABLE     �   CREATE TABLE public.bitacora (
    bitacora_id integer NOT NULL,
    accion character varying(120),
    fecha_accion date,
    tabla_afectada character varying(50)
);
    DROP TABLE public.bitacora;
       public         heap    postgres    false    5            �            1259    18153    bitacora_bitacora_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bitacora_bitacora_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.bitacora_bitacora_id_seq;
       public          postgres    false    5    218            v           0    0    bitacora_bitacora_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.bitacora_bitacora_id_seq OWNED BY public.bitacora.bitacora_id;
          public          postgres    false    217            �            1259    18188    cliente    TABLE     �   CREATE TABLE public.cliente (
    cliente_id integer NOT NULL,
    nombre character varying(50),
    correo character varying(50),
    telefono character varying(50),
    plato_favorito character varying(50)
);
    DROP TABLE public.cliente;
       public         heap    postgres    false    5            �            1259    18187    cliente_cliente_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cliente_cliente_id_seq;
       public          postgres    false    223    5            w           0    0    cliente_cliente_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cliente_cliente_id_seq OWNED BY public.cliente.cliente_id;
          public          postgres    false    222            �            1259    18271    insumo    TABLE     B  CREATE TABLE public.insumo (
    insumo_id integer NOT NULL,
    nombre character varying(50),
    cantidad_disponible integer,
    fecha_caducidad date,
    alerta_stock_bajo boolean,
    sucursal_id integer,
    CONSTRAINT chk_cantidad_disponible CHECK (((cantidad_disponible >= 0) AND (cantidad_disponible <= 100)))
);
    DROP TABLE public.insumo;
       public         heap    postgres    false    5            �            1259    18270    insumo_insumo_id_seq    SEQUENCE     �   CREATE SEQUENCE public.insumo_insumo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.insumo_insumo_id_seq;
       public          postgres    false    234    5            x           0    0    insumo_insumo_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.insumo_insumo_id_seq OWNED BY public.insumo.insumo_id;
          public          postgres    false    233            �            1259    18282    insumo_plato    TABLE     d   CREATE TABLE public.insumo_plato (
    insumo_id integer NOT NULL,
    plato_id integer NOT NULL
);
     DROP TABLE public.insumo_plato;
       public         heap    postgres    false    5            �            1259    18197    mesa    TABLE     �   CREATE TABLE public.mesa (
    mesa_id integer NOT NULL,
    capacidad integer,
    disponibilidad boolean,
    sucursal_id integer
);
    DROP TABLE public.mesa;
       public         heap    postgres    false    5            �            1259    18196    mesa_mesa_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mesa_mesa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.mesa_mesa_id_seq;
       public          postgres    false    225    5            y           0    0    mesa_mesa_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.mesa_mesa_id_seq OWNED BY public.mesa.mesa_id;
          public          postgres    false    224            �            1259    18231    pedido    TABLE     �   CREATE TABLE public.pedido (
    pedido_id integer NOT NULL,
    fecha_pedido date,
    total_pedido double precision,
    cliente_id integer,
    sucursal_id integer,
    mesa_id integer
);
    DROP TABLE public.pedido;
       public         heap    postgres    false    5            �            1259    18230    pedido_pedido_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pedido_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.pedido_pedido_id_seq;
       public          postgres    false    229    5            z           0    0    pedido_pedido_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.pedido_pedido_id_seq OWNED BY public.pedido.pedido_id;
          public          postgres    false    228            �            1259    18255    pedido_plato    TABLE     d   CREATE TABLE public.pedido_plato (
    pedido_id integer NOT NULL,
    plato_id integer NOT NULL
);
     DROP TABLE public.pedido_plato;
       public         heap    postgres    false    5            �            1259    18248    plato    TABLE     �   CREATE TABLE public.plato (
    plato_id integer NOT NULL,
    nombre character varying(50),
    precio double precision,
    descripcion character varying(255),
    CONSTRAINT plato_precio_check CHECK ((precio >= (0)::double precision))
);
    DROP TABLE public.plato;
       public         heap    postgres    false    5            �            1259    18247    plato_plato_id_seq    SEQUENCE     �   CREATE SEQUENCE public.plato_plato_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.plato_plato_id_seq;
       public          postgres    false    231    5            {           0    0    plato_plato_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.plato_plato_id_seq OWNED BY public.plato.plato_id;
          public          postgres    false    230            �            1259    18209    reserva    TABLE     �   CREATE TABLE public.reserva (
    reserva_id integer NOT NULL,
    fecha_reserva date,
    mesa_id integer,
    cliente_id integer,
    estado character varying(50),
    sucursal_id integer
);
    DROP TABLE public.reserva;
       public         heap    postgres    false    5            �            1259    18208    reserva_reserva_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reserva_reserva_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.reserva_reserva_id_seq;
       public          postgres    false    5    227            |           0    0    reserva_reserva_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.reserva_reserva_id_seq OWNED BY public.reserva.reserva_id;
          public          postgres    false    226            �            1259    18166    sucursal    TABLE     �   CREATE TABLE public.sucursal (
    sucursal_id integer NOT NULL,
    nombre_sucursal character varying(50),
    ubicacion character varying(50)
);
    DROP TABLE public.sucursal;
       public         heap    postgres    false    5            �            1259    18165    sucursal_sucursal_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sucursal_sucursal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sucursal_sucursal_id_seq;
       public          postgres    false    5    220            }           0    0    sucursal_sucursal_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sucursal_sucursal_id_seq OWNED BY public.sucursal.sucursal_id;
          public          postgres    false    219            �            1259    18172    sucursal_usuario    TABLE     l   CREATE TABLE public.sucursal_usuario (
    sucursal_id integer NOT NULL,
    usuario_id integer NOT NULL
);
 $   DROP TABLE public.sucursal_usuario;
       public         heap    postgres    false    5            �            1259    18145    usuario    TABLE     �   CREATE TABLE public.usuario (
    usuario_id integer NOT NULL,
    nombre character varying(50),
    rol character varying(50),
    correo character varying(50),
    contrasena character varying(50)
);
    DROP TABLE public.usuario;
       public         heap    postgres    false    5            �            1259    18144    usuario_usuario_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_usuario_id_seq;
       public          postgres    false    216    5            ~           0    0    usuario_usuario_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_usuario_id_seq OWNED BY public.usuario.usuario_id;
          public          postgres    false    215            �           2604    18157    bitacora bitacora_id    DEFAULT     |   ALTER TABLE ONLY public.bitacora ALTER COLUMN bitacora_id SET DEFAULT nextval('public.bitacora_bitacora_id_seq'::regclass);
 C   ALTER TABLE public.bitacora ALTER COLUMN bitacora_id DROP DEFAULT;
       public          postgres    false    218    217    218            �           2604    18191    cliente cliente_id    DEFAULT     x   ALTER TABLE ONLY public.cliente ALTER COLUMN cliente_id SET DEFAULT nextval('public.cliente_cliente_id_seq'::regclass);
 A   ALTER TABLE public.cliente ALTER COLUMN cliente_id DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    18274    insumo insumo_id    DEFAULT     t   ALTER TABLE ONLY public.insumo ALTER COLUMN insumo_id SET DEFAULT nextval('public.insumo_insumo_id_seq'::regclass);
 ?   ALTER TABLE public.insumo ALTER COLUMN insumo_id DROP DEFAULT;
       public          postgres    false    234    233    234            �           2604    18200    mesa mesa_id    DEFAULT     l   ALTER TABLE ONLY public.mesa ALTER COLUMN mesa_id SET DEFAULT nextval('public.mesa_mesa_id_seq'::regclass);
 ;   ALTER TABLE public.mesa ALTER COLUMN mesa_id DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    18234    pedido pedido_id    DEFAULT     t   ALTER TABLE ONLY public.pedido ALTER COLUMN pedido_id SET DEFAULT nextval('public.pedido_pedido_id_seq'::regclass);
 ?   ALTER TABLE public.pedido ALTER COLUMN pedido_id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    18251    plato plato_id    DEFAULT     p   ALTER TABLE ONLY public.plato ALTER COLUMN plato_id SET DEFAULT nextval('public.plato_plato_id_seq'::regclass);
 =   ALTER TABLE public.plato ALTER COLUMN plato_id DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    18212    reserva reserva_id    DEFAULT     x   ALTER TABLE ONLY public.reserva ALTER COLUMN reserva_id SET DEFAULT nextval('public.reserva_reserva_id_seq'::regclass);
 A   ALTER TABLE public.reserva ALTER COLUMN reserva_id DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    18169    sucursal sucursal_id    DEFAULT     |   ALTER TABLE ONLY public.sucursal ALTER COLUMN sucursal_id SET DEFAULT nextval('public.sucursal_sucursal_id_seq'::regclass);
 C   ALTER TABLE public.sucursal ALTER COLUMN sucursal_id DROP DEFAULT;
       public          postgres    false    219    220    220            �           2604    18148    usuario usuario_id    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN usuario_id SET DEFAULT nextval('public.usuario_usuario_id_seq'::regclass);
 A   ALTER TABLE public.usuario ALTER COLUMN usuario_id DROP DEFAULT;
       public          postgres    false    216    215    216            \          0    18154    bitacora 
   TABLE DATA           U   COPY public.bitacora (bitacora_id, accion, fecha_accion, tabla_afectada) FROM stdin;
    public          postgres    false    218   4�       a          0    18188    cliente 
   TABLE DATA           W   COPY public.cliente (cliente_id, nombre, correo, telefono, plato_favorito) FROM stdin;
    public          postgres    false    223   ݑ       l          0    18271    insumo 
   TABLE DATA           y   COPY public.insumo (insumo_id, nombre, cantidad_disponible, fecha_caducidad, alerta_stock_bajo, sucursal_id) FROM stdin;
    public          postgres    false    234   ��       m          0    18282    insumo_plato 
   TABLE DATA           ;   COPY public.insumo_plato (insumo_id, plato_id) FROM stdin;
    public          postgres    false    235   ו       c          0    18197    mesa 
   TABLE DATA           O   COPY public.mesa (mesa_id, capacidad, disponibilidad, sucursal_id) FROM stdin;
    public          postgres    false    225   ��       g          0    18231    pedido 
   TABLE DATA           i   COPY public.pedido (pedido_id, fecha_pedido, total_pedido, cliente_id, sucursal_id, mesa_id) FROM stdin;
    public          postgres    false    229   �       j          0    18255    pedido_plato 
   TABLE DATA           ;   COPY public.pedido_plato (pedido_id, plato_id) FROM stdin;
    public          postgres    false    232   ~�       i          0    18248    plato 
   TABLE DATA           F   COPY public.plato (plato_id, nombre, precio, descripcion) FROM stdin;
    public          postgres    false    231          e          0    18209    reserva 
   TABLE DATA           f   COPY public.reserva (reserva_id, fecha_reserva, mesa_id, cliente_id, estado, sucursal_id) FROM stdin;
    public          postgres    false    227   ~�       ^          0    18166    sucursal 
   TABLE DATA           K   COPY public.sucursal (sucursal_id, nombre_sucursal, ubicacion) FROM stdin;
    public          postgres    false    220   ʚ       _          0    18172    sucursal_usuario 
   TABLE DATA           C   COPY public.sucursal_usuario (sucursal_id, usuario_id) FROM stdin;
    public          postgres    false    221   �       Z          0    18145    usuario 
   TABLE DATA           N   COPY public.usuario (usuario_id, nombre, rol, correo, contrasena) FROM stdin;
    public          postgres    false    216   N�                  0    0    bitacora_bitacora_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.bitacora_bitacora_id_seq', 14, true);
          public          postgres    false    217            �           0    0    cliente_cliente_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.cliente_cliente_id_seq', 6, true);
          public          postgres    false    222            �           0    0    insumo_insumo_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.insumo_insumo_id_seq', 90, true);
          public          postgres    false    233            �           0    0    mesa_mesa_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.mesa_mesa_id_seq', 30, true);
          public          postgres    false    224            �           0    0    pedido_pedido_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.pedido_pedido_id_seq', 8, true);
          public          postgres    false    228            �           0    0    plato_plato_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.plato_plato_id_seq', 15, false);
          public          postgres    false    230            �           0    0    reserva_reserva_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.reserva_reserva_id_seq', 5, true);
          public          postgres    false    226            �           0    0    sucursal_sucursal_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sucursal_sucursal_id_seq', 3, true);
          public          postgres    false    219            �           0    0    usuario_usuario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.usuario_usuario_id_seq', 5, true);
          public          postgres    false    215            �           2606    18159    bitacora bitacora_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (bitacora_id);
 @   ALTER TABLE ONLY public.bitacora DROP CONSTRAINT bitacora_pkey;
       public            postgres    false    218            �           2606    18195    cliente cliente_correo_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_correo_key UNIQUE (correo);
 D   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_correo_key;
       public            postgres    false    223            �           2606    18193    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cliente_id);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    223            �           2606    18276    insumo insumo_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.insumo
    ADD CONSTRAINT insumo_pkey PRIMARY KEY (insumo_id);
 <   ALTER TABLE ONLY public.insumo DROP CONSTRAINT insumo_pkey;
       public            postgres    false    234            �           2606    18286    insumo_plato insumo_plato_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.insumo_plato
    ADD CONSTRAINT insumo_plato_pkey PRIMARY KEY (insumo_id, plato_id);
 H   ALTER TABLE ONLY public.insumo_plato DROP CONSTRAINT insumo_plato_pkey;
       public            postgres    false    235    235            �           2606    18202    mesa mesa_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (mesa_id);
 8   ALTER TABLE ONLY public.mesa DROP CONSTRAINT mesa_pkey;
       public            postgres    false    225            �           2606    18236    pedido pedido_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (pedido_id);
 <   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_pkey;
       public            postgres    false    229            �           2606    18259    pedido_plato pedido_plato_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.pedido_plato
    ADD CONSTRAINT pedido_plato_pkey PRIMARY KEY (pedido_id, plato_id);
 H   ALTER TABLE ONLY public.pedido_plato DROP CONSTRAINT pedido_plato_pkey;
       public            postgres    false    232    232            �           2606    18254    plato plato_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.plato
    ADD CONSTRAINT plato_pkey PRIMARY KEY (plato_id);
 :   ALTER TABLE ONLY public.plato DROP CONSTRAINT plato_pkey;
       public            postgres    false    231            �           2606    18214    reserva reserva_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_pkey PRIMARY KEY (reserva_id);
 >   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_pkey;
       public            postgres    false    227            �           2606    18171    sucursal sucursal_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (sucursal_id);
 @   ALTER TABLE ONLY public.sucursal DROP CONSTRAINT sucursal_pkey;
       public            postgres    false    220            �           2606    18176 &   sucursal_usuario sucursal_usuario_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.sucursal_usuario
    ADD CONSTRAINT sucursal_usuario_pkey PRIMARY KEY (sucursal_id, usuario_id);
 P   ALTER TABLE ONLY public.sucursal_usuario DROP CONSTRAINT sucursal_usuario_pkey;
       public            postgres    false    221    221            �           2606    18152    usuario usuario_correo_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);
 D   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_correo_key;
       public            postgres    false    216            �           2606    18150    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario_id);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    216            �           1259    18505    idx_insumo_alerta    INDEX     d   CREATE INDEX idx_insumo_alerta ON public.insumo USING btree (fecha_caducidad, cantidad_disponible);
 %   DROP INDEX public.idx_insumo_alerta;
       public            postgres    false    234    234            �           1259    18496    indx_pedido    INDEX     Q   CREATE INDEX indx_pedido ON public.pedido USING btree (cliente_id, sucursal_id);
    DROP INDEX public.indx_pedido;
       public            postgres    false    229    229            �           1259    18504    indx_pedido2    INDEX     ]   CREATE INDEX indx_pedido2 ON public.pedido USING btree (cliente_id, sucursal_id, pedido_id);
     DROP INDEX public.indx_pedido2;
       public            postgres    false    229    229    229            �           1259    18495    indx_reserva    INDEX     S   CREATE INDEX indx_reserva ON public.reserva USING btree (cliente_id, sucursal_id);
     DROP INDEX public.indx_reserva;
       public            postgres    false    227    227            �           1259    18497    pedido_plato_indice    INDEX     P   CREATE INDEX pedido_plato_indice ON public.pedido_plato USING btree (plato_id);
 '   DROP INDEX public.pedido_plato_indice;
       public            postgres    false    232            �           2620    18328    pedido bloquear_mesa_por_pedido    TRIGGER     �   CREATE TRIGGER bloquear_mesa_por_pedido AFTER INSERT ON public.pedido FOR EACH ROW EXECUTE FUNCTION public.bloquear_mesa_por_pedido();
 8   DROP TRIGGER bloquear_mesa_por_pedido ON public.pedido;
       public          postgres    false    252    229            �           2620    18324 !   reserva bloquear_mesa_por_reserva    TRIGGER     �   CREATE TRIGGER bloquear_mesa_por_reserva AFTER INSERT ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.bloquear_mesa_por_reserva();
 :   DROP TRIGGER bloquear_mesa_por_reserva ON public.reserva;
       public          postgres    false    236    227            �           2620    18490 )   reserva desbloquear_mesa_por_finalizacion    TRIGGER     �   CREATE TRIGGER desbloquear_mesa_por_finalizacion AFTER UPDATE ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.desbloquear_mesa_por_finalizacion();
 B   DROP TRIGGER desbloquear_mesa_por_finalizacion ON public.reserva;
       public          postgres    false    227    251            �           2620    18503 .   reserva insertar_bitacora_finalizacion_reserva    TRIGGER     �   CREATE TRIGGER insertar_bitacora_finalizacion_reserva AFTER UPDATE ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.insertar_bitacora_finalizacion_reserva();
 G   DROP TRIGGER insertar_bitacora_finalizacion_reserva ON public.reserva;
       public          postgres    false    227    238            �           2620    18494 '   pedido_plato trigger_actualizar_insumos    TRIGGER     �   CREATE TRIGGER trigger_actualizar_insumos AFTER INSERT ON public.pedido_plato FOR EACH ROW EXECUTE FUNCTION public.actualizar_insumos();
 @   DROP TRIGGER trigger_actualizar_insumos ON public.pedido_plato;
       public          postgres    false    250    232            �           2620    18501    mesa trigger_desbloquear_mesa    TRIGGER     �   CREATE TRIGGER trigger_desbloquear_mesa AFTER UPDATE OF disponibilidad ON public.mesa FOR EACH ROW WHEN ((new.disponibilidad = true)) EXECUTE FUNCTION public.desbloquear_mesa_por_pedido();
 6   DROP TRIGGER trigger_desbloquear_mesa ON public.mesa;
       public          postgres    false    225    237    225    225            �           2606    18298    pedido fk_mesa    FK CONSTRAINT     q   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_mesa FOREIGN KEY (mesa_id) REFERENCES public.mesa(mesa_id);
 8   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_mesa;
       public          postgres    false    229    225    4772            �           2606    18287 (   insumo_plato insumo_plato_insumo_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo_plato
    ADD CONSTRAINT insumo_plato_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.insumo(insumo_id);
 R   ALTER TABLE ONLY public.insumo_plato DROP CONSTRAINT insumo_plato_insumo_id_fkey;
       public          postgres    false    4787    234    235            �           2606    18292 '   insumo_plato insumo_plato_plato_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo_plato
    ADD CONSTRAINT insumo_plato_plato_id_fkey FOREIGN KEY (plato_id) REFERENCES public.plato(plato_id);
 Q   ALTER TABLE ONLY public.insumo_plato DROP CONSTRAINT insumo_plato_plato_id_fkey;
       public          postgres    false    4781    231    235            �           2606    18277    insumo insumo_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo
    ADD CONSTRAINT insumo_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 H   ALTER TABLE ONLY public.insumo DROP CONSTRAINT insumo_sucursal_id_fkey;
       public          postgres    false    234    220    4764            �           2606    18203    mesa mesa_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT mesa_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 D   ALTER TABLE ONLY public.mesa DROP CONSTRAINT mesa_sucursal_id_fkey;
       public          postgres    false    220    4764    225            �           2606    18237    pedido pedido_cliente_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(cliente_id);
 G   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_cliente_id_fkey;
       public          postgres    false    229    4770    223            �           2606    18260 (   pedido_plato pedido_plato_pedido_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_plato
    ADD CONSTRAINT pedido_plato_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedido(pedido_id);
 R   ALTER TABLE ONLY public.pedido_plato DROP CONSTRAINT pedido_plato_pedido_id_fkey;
       public          postgres    false    229    4779    232            �           2606    18265 '   pedido_plato pedido_plato_plato_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_plato
    ADD CONSTRAINT pedido_plato_plato_id_fkey FOREIGN KEY (plato_id) REFERENCES public.plato(plato_id);
 Q   ALTER TABLE ONLY public.pedido_plato DROP CONSTRAINT pedido_plato_plato_id_fkey;
       public          postgres    false    232    231    4781            �           2606    18242    pedido pedido_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 H   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_sucursal_id_fkey;
       public          postgres    false    229    220    4764            �           2606    18220    reserva reserva_cliente_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(cliente_id);
 I   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_cliente_id_fkey;
       public          postgres    false    227    4770    223            �           2606    18215    reserva reserva_mesa_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_mesa_id_fkey FOREIGN KEY (mesa_id) REFERENCES public.mesa(mesa_id);
 F   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_mesa_id_fkey;
       public          postgres    false    227    4772    225            �           2606    18225     reserva reserva_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 J   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_sucursal_id_fkey;
       public          postgres    false    227    4764    220            �           2606    18177 2   sucursal_usuario sucursal_usuario_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursal_usuario
    ADD CONSTRAINT sucursal_usuario_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 \   ALTER TABLE ONLY public.sucursal_usuario DROP CONSTRAINT sucursal_usuario_sucursal_id_fkey;
       public          postgres    false    221    4764    220            �           2606    18182 1   sucursal_usuario sucursal_usuario_usuario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursal_usuario
    ADD CONSTRAINT sucursal_usuario_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(usuario_id);
 [   ALTER TABLE ONLY public.sucursal_usuario DROP CONSTRAINT sucursal_usuario_usuario_id_fkey;
       public          postgres    false    221    4760    216            \   �   x���J-N-*KTH��K�ɬJLI�R0�4202�54 "�"�. ��&9���<��T�����b�ZC��b5׈��h\qRN~ai*P��X���J(�d5ݘ3�SԄ3�"�m�
�9
�)�)�@��s3�3s2�z�8!�\1z\\\ +�K�      a   �   x�e�A
�0 ��+��H�57�Pzh�������BTJ}}K#%m/�{�aX�N��ި��KX
(�Ym�wg��������ZO��bh զ�G����7���Q�5dQ"4ۣw4m��evD� �"/H#9;t~ı�������C��s��1R�      l   ;  x���M��0���)r��dY��St��I;]v#$JcԱ;�bn�3�be&�~��~�H>~�l�q]�ٹqt��^�j[��(��`%<w�o7��c[�5��L�Cvm��8v�r)ﲀ��;��{�o�+����fۃVQ�7Kh����y7;`��.��^�u�?]��o��V���Ѓ�i�O�����6x~�@-��Е��i���M��1����|����?z��>g�2��ݟP	Fs�V8���]��YUR׸���ع�s�y[%�}k�-����|���<��!�7�ع����'G����Ժ���p���E$Ъ%�B���FY�P��ij�c]�1�]7�s�.T�?کk�ql�7arJ��U���y[��)ՄRRJkB)ʑҚP�bBi8�)E�P�sJ1 R��(.�*�S���&�bHNiE(��(U�m�#�L產�S*J��)U�RH)ՄR�sJ���R���P�쟥�@��9��%��Uuu�T�|�	�KޅRQ��KI[��]*sJQH)5�o�#�ɾc^L(MV�7JuN)$�T攢v��)Ei�KeN)��]*sJE�3JC��C'�T攢�S*W��һs�RH)e%YW��e���~SC0Ÿ�L	�(L��t�JZ���TR�ĭ��C߂����S�pZ�����Pq`~I/繄w.RE$Q0�{�}D�ɓ��ix}�~Y�)*W�L��c��櫿_����7A!~m��lN������>I���ܷC?���E�A�x!�)��S`P�����\�����9LEa����9p��Œ�5.+A�:�9����FPI��������!�UMPeŏEQ���t<      m   �  x�%�A��8��a��
b����a#� ��������h�f������L�xi�������Y5��w�g��DQ֝wʡey��GDw"e����iolΛ(J�����ӛ^3绾���#�D��y���%�L�u��Q9ϖ�&�|d��: 8�=�%��Q�P8�8���ܰ[��5x_�!b��@6�f�ـ6��j��06���n��  p~ 7� 6������P�6�w��y��Aߠ7��w';�;����wt8�Nvt8:���ǃ#�1�!�b�Q�l��;ǅp!\p!\p!\p!\.�a@��iE.��pQ(\�&��E��.���p!\(G\.������B����䍋�e\(.�����J޸�q���q��P\ܸP\(.7�+.���{��B��      c   X   x�5��	�0��6�=t��0�?{��Ű y��4�PS-u�[=�w�_�� ,�����`�68Bv�CO,~��k�/3{D�(�      g   b   x�m��� ����	��Kt���D �G��Ζ�0�%�D�:�0���פLl�Q'��/(s�I݉���"���!�;����<V�M�?ﷴ�q{�"� �      j   4   x���  �����z�߁+����(�*|C��i��?�Ň�-I���      i   �  x��SKN�0]OO���p)�nS�"DU�6lFɴ�p��N ���3pN�$��-XY���f�X��<#�
���~��+�X&��}zBGZc$b�J���N�)��Y��������d*�#r��W7w�֔@$.�cb�5~�P�փk����^�}>/��&ZݓZ�p��ֶZ�Np��)C�皂�m��:�'��]�ai��u�-�#��z�<�1a!��=������s���1&��#�����L���-��?�&�T���G����0����u���Ҥ�
�"q�sz{��'M��\L2�%�ěZo�M�
����؍aJ	�]���2dP&B]��^��7 �p�xZ�ĸ���vQe�k��J%����W動D��-���Ǵ4��Nqy��k�eF��.���v�M.������t:��c�      e   <   x�3�4202�50"NsNCN7O?G�(GGNC.c���q�!���)YC�=... \��      ^   ;   x�3�.M.-*N�QpN�+)����KT0�2BH����B�M�����EP�F\1z\\\ ��      _   )   x�3�4�2�4�2�4�F\�@l�id� � ڔ+F��� f��      Z   �   x�u�;
�@Dk�0�z�@�@�F�p�� y7��f���l,�'��SH�4AW*���P��8��%��̞yT��դ{��-��d�,����=pc�x�9pMp<]�6�ǲ�#�D�0^X�     