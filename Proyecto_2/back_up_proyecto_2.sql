PGDMP  /            
    	    |         
   proyecto_2    16.3    16.3 g    g           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            h           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            i           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            j           1262    17876 
   proyecto_2    DATABASE     �   CREATE DATABASE proyecto_2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Guatemala.1252';
    DROP DATABASE proyecto_2;
                postgres    false                        2615    18143    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            k           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                   postgres    false    5            l           0    0    SCHEMA public    ACL     +   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
                   postgres    false    5            �            1255    18327    bloquear_mesa_por_pedido()    FUNCTION     '  CREATE FUNCTION public.bloquear_mesa_por_pedido() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id;


    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;

    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.bloquear_mesa_por_pedido();
       public          postgres    false    5            �            1255    18323    bloquear_mesa_por_reserva()    FUNCTION     K  CREATE FUNCTION public.bloquear_mesa_por_reserva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id AND NEW.estado_reserva = 'VIGENTE';


    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;

    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.bloquear_mesa_por_reserva();
       public          postgres    false    5            �            1255    18325 #   desbloquear_mesa_por_finalizacion()    FUNCTION     #  CREATE FUNCTION public.desbloquear_mesa_por_finalizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    accion_personalizada TEXT; 
BEGIN

    IF NEW.estado = 'FINALIZADA' THEN

        UPDATE mesa
        SET disponibilidad = TRUE
        WHERE mesa.mesa_id = NEW.mesa_id;

        RAISE NOTICE 'La mesa con el ID % está desbloqueada', NEW.mesa_id; 
    ELSE
        RAISE NOTICE 'El estado de la reserva no es FINALIZADA, no se realiza ninguna acción.';
    END IF;

	accion_personalizada := 'Finalización de reserva';
        INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
        VALUES (accion_personalizada, CURRENT_DATE, 'mesa'); 
    
        RAISE NOTICE 'El estado de la reserva no es FINALIZADA, no se realiza ninguna acción.';

    RETURN NEW; 
END;
$$;
 :   DROP FUNCTION public.desbloquear_mesa_por_finalizacion();
       public          postgres    false    5            �            1255    18329 (   insertar_bitacora_finalizacion_reserva()    FUNCTION     �  CREATE FUNCTION public.insertar_bitacora_finalizacion_reserva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
accion_personalizada text;
reserva_id2 text;
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
       public          postgres    false    5    218            m           0    0    bitacora_bitacora_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.bitacora_bitacora_id_seq OWNED BY public.bitacora.bitacora_id;
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
       public          postgres    false    223    5            n           0    0    cliente_cliente_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cliente_cliente_id_seq OWNED BY public.cliente.cliente_id;
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
       public          postgres    false    5    234            o           0    0    insumo_insumo_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.insumo_insumo_id_seq OWNED BY public.insumo.insumo_id;
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
       public          postgres    false    225    5            p           0    0    mesa_mesa_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.mesa_mesa_id_seq OWNED BY public.mesa.mesa_id;
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
       public          postgres    false    5    229            q           0    0    pedido_pedido_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.pedido_pedido_id_seq OWNED BY public.pedido.pedido_id;
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
       public          postgres    false    231    5            r           0    0    plato_plato_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.plato_plato_id_seq OWNED BY public.plato.plato_id;
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
       public          postgres    false    5    227            s           0    0    reserva_reserva_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.reserva_reserva_id_seq OWNED BY public.reserva.reserva_id;
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
       public          postgres    false    220    5            t           0    0    sucursal_sucursal_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sucursal_sucursal_id_seq OWNED BY public.sucursal.sucursal_id;
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
       public          postgres    false    5    216            u           0    0    usuario_usuario_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_usuario_id_seq OWNED BY public.usuario.usuario_id;
          public          postgres    false    215            �           2604    18157    bitacora bitacora_id    DEFAULT     |   ALTER TABLE ONLY public.bitacora ALTER COLUMN bitacora_id SET DEFAULT nextval('public.bitacora_bitacora_id_seq'::regclass);
 C   ALTER TABLE public.bitacora ALTER COLUMN bitacora_id DROP DEFAULT;
       public          postgres    false    217    218    218            �           2604    18191    cliente cliente_id    DEFAULT     x   ALTER TABLE ONLY public.cliente ALTER COLUMN cliente_id SET DEFAULT nextval('public.cliente_cliente_id_seq'::regclass);
 A   ALTER TABLE public.cliente ALTER COLUMN cliente_id DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    18274    insumo insumo_id    DEFAULT     t   ALTER TABLE ONLY public.insumo ALTER COLUMN insumo_id SET DEFAULT nextval('public.insumo_insumo_id_seq'::regclass);
 ?   ALTER TABLE public.insumo ALTER COLUMN insumo_id DROP DEFAULT;
       public          postgres    false    234    233    234            �           2604    18200    mesa mesa_id    DEFAULT     l   ALTER TABLE ONLY public.mesa ALTER COLUMN mesa_id SET DEFAULT nextval('public.mesa_mesa_id_seq'::regclass);
 ;   ALTER TABLE public.mesa ALTER COLUMN mesa_id DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    18234    pedido pedido_id    DEFAULT     t   ALTER TABLE ONLY public.pedido ALTER COLUMN pedido_id SET DEFAULT nextval('public.pedido_pedido_id_seq'::regclass);
 ?   ALTER TABLE public.pedido ALTER COLUMN pedido_id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    18251    plato plato_id    DEFAULT     p   ALTER TABLE ONLY public.plato ALTER COLUMN plato_id SET DEFAULT nextval('public.plato_plato_id_seq'::regclass);
 =   ALTER TABLE public.plato ALTER COLUMN plato_id DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    18212    reserva reserva_id    DEFAULT     x   ALTER TABLE ONLY public.reserva ALTER COLUMN reserva_id SET DEFAULT nextval('public.reserva_reserva_id_seq'::regclass);
 A   ALTER TABLE public.reserva ALTER COLUMN reserva_id DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    18169    sucursal sucursal_id    DEFAULT     |   ALTER TABLE ONLY public.sucursal ALTER COLUMN sucursal_id SET DEFAULT nextval('public.sucursal_sucursal_id_seq'::regclass);
 C   ALTER TABLE public.sucursal ALTER COLUMN sucursal_id DROP DEFAULT;
       public          postgres    false    220    219    220            �           2604    18148    usuario usuario_id    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN usuario_id SET DEFAULT nextval('public.usuario_usuario_id_seq'::regclass);
 A   ALTER TABLE public.usuario ALTER COLUMN usuario_id DROP DEFAULT;
       public          postgres    false    216    215    216            S          0    18154    bitacora 
   TABLE DATA           U   COPY public.bitacora (bitacora_id, accion, fecha_accion, tabla_afectada) FROM stdin;
    public          postgres    false    218   ��       X          0    18188    cliente 
   TABLE DATA           W   COPY public.cliente (cliente_id, nombre, correo, telefono, plato_favorito) FROM stdin;
    public          postgres    false    223   ʀ       c          0    18271    insumo 
   TABLE DATA           y   COPY public.insumo (insumo_id, nombre, cantidad_disponible, fecha_caducidad, alerta_stock_bajo, sucursal_id) FROM stdin;
    public          postgres    false    234   e�       d          0    18282    insumo_plato 
   TABLE DATA           ;   COPY public.insumo_plato (insumo_id, plato_id) FROM stdin;
    public          postgres    false    235   ��       Z          0    18197    mesa 
   TABLE DATA           O   COPY public.mesa (mesa_id, capacidad, disponibilidad, sucursal_id) FROM stdin;
    public          postgres    false    225   l�       ^          0    18231    pedido 
   TABLE DATA           i   COPY public.pedido (pedido_id, fecha_pedido, total_pedido, cliente_id, sucursal_id, mesa_id) FROM stdin;
    public          postgres    false    229   ҆       a          0    18255    pedido_plato 
   TABLE DATA           ;   COPY public.pedido_plato (pedido_id, plato_id) FROM stdin;
    public          postgres    false    232   $�       `          0    18248    plato 
   TABLE DATA           F   COPY public.plato (plato_id, nombre, precio, descripcion) FROM stdin;
    public          postgres    false    231   Z�       \          0    18209    reserva 
   TABLE DATA           f   COPY public.reserva (reserva_id, fecha_reserva, mesa_id, cliente_id, estado, sucursal_id) FROM stdin;
    public          postgres    false    227   �       U          0    18166    sucursal 
   TABLE DATA           K   COPY public.sucursal (sucursal_id, nombre_sucursal, ubicacion) FROM stdin;
    public          postgres    false    220   ]�       V          0    18172    sucursal_usuario 
   TABLE DATA           C   COPY public.sucursal_usuario (sucursal_id, usuario_id) FROM stdin;
    public          postgres    false    221   ��       Q          0    18145    usuario 
   TABLE DATA           N   COPY public.usuario (usuario_id, nombre, rol, correo, contrasena) FROM stdin;
    public          postgres    false    216   ߉       v           0    0    bitacora_bitacora_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.bitacora_bitacora_id_seq', 9, true);
          public          postgres    false    217            w           0    0    cliente_cliente_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.cliente_cliente_id_seq', 5, true);
          public          postgres    false    222            x           0    0    insumo_insumo_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.insumo_insumo_id_seq', 90, true);
          public          postgres    false    233            y           0    0    mesa_mesa_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.mesa_mesa_id_seq', 30, true);
          public          postgres    false    224            z           0    0    pedido_pedido_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.pedido_pedido_id_seq', 4, true);
          public          postgres    false    228            {           0    0    plato_plato_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.plato_plato_id_seq', 15, false);
          public          postgres    false    230            |           0    0    reserva_reserva_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.reserva_reserva_id_seq', 3, true);
          public          postgres    false    226            }           0    0    sucursal_sucursal_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sucursal_sucursal_id_seq', 3, true);
          public          postgres    false    219            ~           0    0    usuario_usuario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.usuario_usuario_id_seq', 4, true);
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
       public            postgres    false    216            �           2620    18328    pedido bloquear_mesa_por_pedido    TRIGGER     �   CREATE TRIGGER bloquear_mesa_por_pedido AFTER INSERT ON public.pedido FOR EACH ROW EXECUTE FUNCTION public.bloquear_mesa_por_pedido();
 8   DROP TRIGGER bloquear_mesa_por_pedido ON public.pedido;
       public          postgres    false    229    237            �           2620    18324 !   reserva bloquear_mesa_por_reserva    TRIGGER     �   CREATE TRIGGER bloquear_mesa_por_reserva AFTER INSERT ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.bloquear_mesa_por_reserva();
 :   DROP TRIGGER bloquear_mesa_por_reserva ON public.reserva;
       public          postgres    false    227    236            �           2620    18490 )   reserva desbloquear_mesa_por_finalizacion    TRIGGER     �   CREATE TRIGGER desbloquear_mesa_por_finalizacion AFTER UPDATE ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.desbloquear_mesa_por_finalizacion();
 B   DROP TRIGGER desbloquear_mesa_por_finalizacion ON public.reserva;
       public          postgres    false    250    227            �           2620    18330 .   reserva insertar_bitacora_finalizacion_reserva    TRIGGER     �   CREATE TRIGGER insertar_bitacora_finalizacion_reserva AFTER UPDATE ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.insertar_bitacora_finalizacion_reserva();
 G   DROP TRIGGER insertar_bitacora_finalizacion_reserva ON public.reserva;
       public          postgres    false    227    238            �           2606    18298    pedido fk_mesa    FK CONSTRAINT     q   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_mesa FOREIGN KEY (mesa_id) REFERENCES public.mesa(mesa_id);
 8   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_mesa;
       public          postgres    false    4770    225    229            �           2606    18287 (   insumo_plato insumo_plato_insumo_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo_plato
    ADD CONSTRAINT insumo_plato_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.insumo(insumo_id);
 R   ALTER TABLE ONLY public.insumo_plato DROP CONSTRAINT insumo_plato_insumo_id_fkey;
       public          postgres    false    234    235    4780            �           2606    18292 '   insumo_plato insumo_plato_plato_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo_plato
    ADD CONSTRAINT insumo_plato_plato_id_fkey FOREIGN KEY (plato_id) REFERENCES public.plato(plato_id);
 Q   ALTER TABLE ONLY public.insumo_plato DROP CONSTRAINT insumo_plato_plato_id_fkey;
       public          postgres    false    231    235    4776            �           2606    18277    insumo insumo_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insumo
    ADD CONSTRAINT insumo_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 H   ALTER TABLE ONLY public.insumo DROP CONSTRAINT insumo_sucursal_id_fkey;
       public          postgres    false    234    220    4762            �           2606    18203    mesa mesa_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT mesa_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 D   ALTER TABLE ONLY public.mesa DROP CONSTRAINT mesa_sucursal_id_fkey;
       public          postgres    false    4762    225    220            �           2606    18237    pedido pedido_cliente_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(cliente_id);
 G   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_cliente_id_fkey;
       public          postgres    false    4768    229    223            �           2606    18260 (   pedido_plato pedido_plato_pedido_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_plato
    ADD CONSTRAINT pedido_plato_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedido(pedido_id);
 R   ALTER TABLE ONLY public.pedido_plato DROP CONSTRAINT pedido_plato_pedido_id_fkey;
       public          postgres    false    232    4774    229            �           2606    18265 '   pedido_plato pedido_plato_plato_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_plato
    ADD CONSTRAINT pedido_plato_plato_id_fkey FOREIGN KEY (plato_id) REFERENCES public.plato(plato_id);
 Q   ALTER TABLE ONLY public.pedido_plato DROP CONSTRAINT pedido_plato_plato_id_fkey;
       public          postgres    false    231    4776    232            �           2606    18242    pedido pedido_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 H   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_sucursal_id_fkey;
       public          postgres    false    4762    229    220            �           2606    18220    reserva reserva_cliente_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(cliente_id);
 I   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_cliente_id_fkey;
       public          postgres    false    4768    223    227            �           2606    18215    reserva reserva_mesa_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_mesa_id_fkey FOREIGN KEY (mesa_id) REFERENCES public.mesa(mesa_id);
 F   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_mesa_id_fkey;
       public          postgres    false    225    227    4770            �           2606    18225     reserva reserva_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 J   ALTER TABLE ONLY public.reserva DROP CONSTRAINT reserva_sucursal_id_fkey;
       public          postgres    false    227    4762    220            �           2606    18177 2   sucursal_usuario sucursal_usuario_sucursal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursal_usuario
    ADD CONSTRAINT sucursal_usuario_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursal(sucursal_id);
 \   ALTER TABLE ONLY public.sucursal_usuario DROP CONSTRAINT sucursal_usuario_sucursal_id_fkey;
       public          postgres    false    4762    221    220            �           2606    18182 1   sucursal_usuario sucursal_usuario_usuario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sucursal_usuario
    ADD CONSTRAINT sucursal_usuario_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(usuario_id);
 [   ALTER TABLE ONLY public.sucursal_usuario DROP CONSTRAINT sucursal_usuario_usuario_id_fkey;
       public          postgres    false    4758    221    216            S   2   x���J-N-*KTH��K�ɬJLI�R0�4202�54 "�"��=... j{      X   �   x�3��)�,鹉�9z�����F�F�F����UU�
��E��E�%�\Ɯ�)E�I���������!T�Gbybfb^"�	PiQr%�D���������
���ΉE9��P�!��$'??��������ݒ=... ��?c      c   *  x�m��r�0���)���s%��әL�n��xv�]�,0��!o�g�U	ƶ�!Y��!��ռ����-h2��^�}!�"��0�������&�r�Y��M{�ޕ�ٚ4IJOv��<]\0_�
���{�ܲ�o߾�Z�����=��.��@�>�U���ǡ���r�����n}�y�/�� ��c����Еt������#	O�`�4���b+*
�����̠�o�=X��d�]L��.����Yl��ł�r���
Ю���H�8��8@�JWVC{;�M�M���v��{��]k�9��=m�fz3�Gb��!�n0ǋ&-��å�/��l�E;�\�<�����q�V[��-�,��\�q�.a��&ȷU[�v��h�m��;ܘ�V",����~1�E�;�p���u"���7p8���%t�_�ߛ��al�7��f��YAȬT�ohJE�DicS�Yc8k'�1�BS:QN�X�D���uh� �Y�-�(j+���Bh� E9 Z1@Q� ��.3TR@1  �α� �ܖ�,�b�b�d��L@k�h�@�yn��H-r��P�Պ���TZ�|1�h���:�֊�Zh�����ķ����EV�ө��N(J�"O�Ƅ6�P�����P�SB�o�������O���YN()j�*J(
1��5������uDht���ՔP�Nh2�ڟPM	E)9���!�*Jh�iBh䶫���(�(RBU⚦���B1 &4�_�nh2O�!�M�7S��E�#�0DQ�oh��M�����S�e�`tR      d   �  x�%�A��8��a��
b����a#� ��������h�f������L�xi�������Y5��w�g��DQ֝wʡey��GDw"e����iolΛ(J�����ӛ^3绾���#�D��y���%�L�u��Q9ϖ�&�|d��: 8�=�%��Q�P8�8���ܰ[��5x_�!b��@6�f�ـ6��j��06���n��  p~ 7� 6������P�6�w��y��Aߠ7��w';�;����wt8�Nvt8:���ǃ#�1�!�b�Q�l��;ǅp!\p!\p!\p!\.�a@��iE.��pQ(\�&��E��.���p!\(G\.������B����䍋�e\(.�����J޸�q���q��P\ܸP\(.7�+.���{��B��      Z   V   x�5��	�0ѳUL�o����O �s�BHު=�-�TK��V����a^`�	��сH� 	
0�!����9������B�(�      ^   B   x�E��	�0����]�����H�����g9jBH��E���9/?G��3"���i�0�$�i      a   &   x�3�4�2�4bc.# ��M�|N 6����� Th      `   �  x��SKN�0]OO���p)�nS�"DU�6lFɴ�p��N ���3pN�$��-XY���f�X��<#�
���~��+�X&��}zBGZc$b�J���N�)��Y��������d*�#r��W7w�֔@$.�cb�5~�P�փk����^�}>/��&ZݓZ�p��ֶZ�Np��)C�皂�m��:�'��]�ai��u�-�#��z�<�1a!��=������s���1&��#�����L���-��?�&�T���G����0����u���Ҥ�
�"q�sz{��'M��\L2�%�ěZo�M�
����؍aJ	�]���2dP&B]��^��7 �p�xZ�ĸ���vQe�k��J%����W動D��-���Ǵ4��Nqy��k�eF��.���v�M.������t:��c�      \   7   x�3�4202�50"NsNCN7O?G�(GGNC.c���q�!��W� �O&      U   ;   x�3�.M.-*N�QpN�+)����KT0�2BH����B�M�����EP�F\1z\\\ ��      V   '   x�3�4�2�4�2�4�F\�@l�id� �&\1z\\\ Tf      Q   w   x�u�K
�@ׯ�� �� �M3ӋH�-ݙ�;
�fY�+^�{a�M\t�+�����K�lE2ݜC�{��s^g���l��ϵ��F\�<$���O��H��ʚ�?�n��:"��6J�     