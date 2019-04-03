
-- TO DO
-- Dodac ograniczenie na wstawianie zajec, ktore juz w danym obiekcie sie o danym czasie odbywaja
-- 
/*

--DROP ALL SEQUENCES
BEGIN
  --Bye Sequences!
  FOR i IN (SELECT us.sequence_name
              FROM USER_SEQUENCES us) LOOP
    EXECUTE IMMEDIATE 'drop sequence '|| i.sequence_name ||'';
  END LOOP;

END;
/
 
-- DROP ALL TABLES
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
/

*/

CREATE TABLE karnet (
    klient_id_klienta   INTEGER NOT NULL,
    zajecia_id_zajec    INTEGER NOT NULL,
    cena                NUMBER(6,2) NOT NULL,
    data_rozp           DATE NOT NULL,
    data_zakon          DATE NOT NULL
);

ALTER TABLE karnet ADD CONSTRAINT karnet_pk PRIMARY KEY ( klient_id_klienta,
zajecia_id_zajec );

CREATE TABLE klient (
    id_klienta   INTEGER NOT NULL,
    nazwisko     VARCHAR2(50) NOT NULL,
    imie         VARCHAR2(50) NOT NULL
);

ALTER TABLE klient ADD CONSTRAINT klient_pk PRIMARY KEY ( id_klienta );

CREATE TABLE obiekt_sportowy (
    id_obiektu    INTEGER NOT NULL,
    lokalizacja   VARCHAR2(50) NOT NULL,
    nazwa         VARCHAR2(50) NOT NULL,
    typ_obiektu   VARCHAR2(50) NOT NULL
);

ALTER TABLE obiekt_sportowy ADD CONSTRAINT obiekt_sportowy_pk PRIMARY KEY ( id_obiektu );

CREATE TABLE pracownik (
    pesel      VARCHAR2(11) NOT NULL,
    nazwisko   VARCHAR2(50) NOT NULL,
    imie       VARCHAR2(50) NOT NULL,
    funkcja    VARCHAR2(50) NOT NULL,
    placa      NUMBER(7,2)  NOT NULL
);

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( pesel );

--CREATE TABLE uczestnik_zawody (
--    zawody_nazwa      VARCHAR2(50) NOT NULL,
--    uczestnik_pesel   VARCHAR2(11) NOT NULL
--);
--
--ALTER TABLE uczestnik_zawody ADD CONSTRAINT uczestnik_zawody_pk PRIMARY KEY ( zawody_nazwa,
--uczestnik_pesel );

CREATE TABLE sala (
    nr_sali                      VARCHAR2(50) NOT NULL,
    obiekt_sportowy_id_obiektu   INTEGER NOT NULL
);

ALTER TABLE sala ADD CONSTRAINT sala_pk PRIMARY KEY ( obiekt_sportowy_id_obiektu,
nr_sali );

CREATE TABLE trener (
    pesel        VARCHAR2(11) NOT NULL,
    dyscyplina   VARCHAR2(50) NOT NULL
);

ALTER TABLE trener ADD CONSTRAINT trener_pk PRIMARY KEY ( pesel );

CREATE TABLE uczestnik (
    id_uczestnika   INTEGER NOT NULL,
    pesel      VARCHAR2(11) NOT NULL,
    nazwisko   VARCHAR2(50) NOT NULL,
    imie       VARCHAR2(20) NOT NULL,
    oplacony   INTEGER NOT NULL,
    zawody_nazwa      VARCHAR2(50) NOT NULL
);

ALTER TABLE uczestnik ADD CONSTRAINT uczestnik_pk PRIMARY KEY ( id_uczestnika );

CREATE TABLE wyposazenie (
    id_wyposazenia               INTEGER NOT NULL,
    nazwa                        VARCHAR2(50) NOT NULL,
    dyscyplina                   VARCHAR2(50),
    ilosc                        INTEGER,
    obiekt_sportowy_id_obiektu   INTEGER,
    sala_obiekt_sportowy_id_ob   INTEGER,
    sala_nr_sali                 VARCHAR2(50)
);

ALTER TABLE wyposazenie
    ADD CONSTRAINT arc_2 CHECK (
        (
            ( obiekt_sportowy_id_obiektu IS NOT NULL )
            AND ( sala_obiekt_sportowy_id_ob IS NULL )
            AND ( sala_nr_sali IS NULL )
        )
        OR (
            ( sala_obiekt_sportowy_id_ob IS NOT NULL )
            AND ( sala_nr_sali IS NOT NULL )
            AND ( obiekt_sportowy_id_obiektu IS NULL )
        )
    );

ALTER TABLE wyposazenie ADD CONSTRAINT wyposazenie_pk PRIMARY KEY ( id_wyposazenia );

CREATE TABLE zajecia (
    id_zajec                     INTEGER NOT NULL,
    dzien_tygodnia               VARCHAR2(20) NOT NULL,
    godzina_rozp                 DATE NOT NULL,
    godzina_zakon                DATE NOT NULL,
    dyscyplina                   VARCHAR2(50) NOT NULL,
    cena                         NUMBER(6,2) NOT NULL,
    trener_pesel                 VARCHAR2(11),
    obiekt_sportowy_id_obiektu   INTEGER,
    sala_obiekt_sportowy_id_ob   INTEGER,
    sala_nr_sali                 VARCHAR2(50)
);

ALTER TABLE zajecia
    ADD CONSTRAINT arc_1 CHECK (
        (
            ( obiekt_sportowy_id_obiektu IS NOT NULL )
            AND ( sala_obiekt_sportowy_id_ob IS NULL )
            AND ( sala_nr_sali IS NULL )
        )
        OR (
            ( sala_obiekt_sportowy_id_ob IS NOT NULL )
            AND ( sala_nr_sali IS NOT NULL )
            AND ( obiekt_sportowy_id_obiektu IS NULL )
        )
    );

ALTER TABLE zajecia ADD CONSTRAINT zajecia_pk PRIMARY KEY ( id_zajec );

CREATE TABLE zawody (
    nazwa                        VARCHAR2(50) NOT NULL,
    data                         DATE NOT NULL,
    dyscyplina                   VARCHAR2(50) NOT NULL,
    oplata_startowa              NUMBER(6,2),
    obiekt_sportowy_id_obiektu   INTEGER NOT NULL
);

ALTER TABLE zawody ADD CONSTRAINT zawody_pk PRIMARY KEY ( nazwa );

ALTER TABLE karnet
    ADD CONSTRAINT karnet_klient_fk FOREIGN KEY ( klient_id_klienta )
        REFERENCES klient ( id_klienta ) ON DELETE CASCADE;

ALTER TABLE karnet
    ADD CONSTRAINT karnet_zajecia_fk FOREIGN KEY ( zajecia_id_zajec )
        REFERENCES zajecia ( id_zajec ) ON DELETE CASCADE;

ALTER TABLE uczestnik
    ADD CONSTRAINT uczestnik_zawody_fk FOREIGN KEY ( zawody_nazwa )
        REFERENCES zawody ( nazwa ) ON DELETE CASCADE;

--ALTER TABLE uczestnik_zawody
--    ADD CONSTRAINT uczestnik_zawody_uczestnik_fk FOREIGN KEY ( uczestnik_pesel )
--        REFERENCES uczestnik ( pesel );
--
--ALTER TABLE uczestnik_zawody
--    ADD CONSTRAINT uczestnik_zawody_zawody_fk FOREIGN KEY ( zawody_nazwa )
--        REFERENCES zawody ( nazwa );

ALTER TABLE sala
    ADD CONSTRAINT sala_obiekt_sportowy_fk FOREIGN KEY ( obiekt_sportowy_id_obiektu )
        REFERENCES obiekt_sportowy ( id_obiektu ) ON DELETE CASCADE;

ALTER TABLE trener
    ADD CONSTRAINT trener_pracownik_fk FOREIGN KEY ( pesel )
        REFERENCES pracownik ( pesel ) ON DELETE CASCADE;

ALTER TABLE wyposazenie
    ADD CONSTRAINT wyposazenie_obiekt_sportowy_fk FOREIGN KEY ( obiekt_sportowy_id_obiektu )
        REFERENCES obiekt_sportowy ( id_obiektu ) ON DELETE CASCADE;

ALTER TABLE wyposazenie
    ADD CONSTRAINT wyposazenie_sala_fk FOREIGN KEY ( sala_obiekt_sportowy_id_ob,
    sala_nr_sali )
        REFERENCES sala ( obiekt_sportowy_id_obiektu,
        nr_sali ) ON DELETE CASCADE;

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_obiekt_sportowy_fk FOREIGN KEY ( obiekt_sportowy_id_obiektu )
        REFERENCES obiekt_sportowy ( id_obiektu ) ON DELETE SET NULL;

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_sala_fk FOREIGN KEY ( sala_obiekt_sportowy_id_ob,
    sala_nr_sali )
        REFERENCES sala ( obiekt_sportowy_id_obiektu,
        nr_sali ) ON DELETE SET NULL;

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_trener_fk FOREIGN KEY ( trener_pesel )
        REFERENCES trener ( pesel ) ON DELETE SET NULL;

ALTER TABLE zawody
    ADD CONSTRAINT zawody_obiekt_sportowy_fk FOREIGN KEY ( obiekt_sportowy_id_obiektu )
        REFERENCES obiekt_sportowy ( id_obiektu ) ON DELETE SET NULL;
        

CREATE OR REPLACE FUNCTION ilu_tren_w_obiekcie(id_obiektu IN INTEGER) RETURN NUMBER IS
    CURSOR c_w_obiekcie IS
        SELECT COUNT(DISTINCT(trener_pesel)) 
        FROM zajecia
        WHERE obiekt_sportowy_id_obiektu = id_obiektu;
    CURSOR c_w_sali IS 
        SELECT COUNT(DISTINCT(trener_pesel)) 
        FROM zajecia
        WHERE sala_obiekt_sportowy_id_ob = id_obiektu;
    w_obiekcie NUMBER;
    w_sali NUMBER;
    sumarycznie NUMBER;
    BEGIN
        OPEN c_w_obiekcie;
        FETCH c_w_obiekcie INTO w_obiekcie;
        CLOSE c_w_obiekcie;
        OPEN c_w_sali;
        FETCH c_w_sali INTO w_sali;
        CLOSE c_w_sali;
        sumarycznie := w_sali + w_obiekcie;
        RETURN sumarycznie;
    END ilu_tren_w_obiekcie;
/

CREATE OR REPLACE FUNCTION podatek (PESEL_pr IN STRING) RETURN NUMBER IS
    CURSOR c_pracownik IS
        SELECT * FROM pracownik
        WHERE PESEL = PESEL_pr;
    v_pracownik pracownik%ROWTYPE;
    v_roczne_zarobki NUMBER;
    v_podatek NUMBER;
    BEGIN
        OPEN c_pracownik;
        FETCH c_pracownik INTO v_pracownik;
        CLOSE c_pracownik;
        v_roczne_zarobki := 12 * v_pracownik.placa;
        IF (v_roczne_zarobki < 8000) THEN v_podatek := 0;
        ELSIF (v_roczne_zarobki BETWEEN 8000 AND 85528) THEN v_podatek := 0.18 * v_roczne_zarobki;  
        ELSE v_podatek := 15395.04 + 0.32 * (v_roczne_zarobki-85528);
        END IF;
        RETURN v_podatek;
    END podatek;
/

CREATE OR REPLACE PROCEDURE usun_stare_karnety IS
BEGIN
    DELETE FROM karnet
    WHERE data_zakon < CURRENT_DATE;
END usun_stare_karnety;
/

-- Nie działa, ale może się przyda :) 
--CREATE OR REPLACE PROCEDURE zaktualizuj_sale(stary_nr_sali IN STRING, stare_id_budynku IN INTEGER, nowy_nr_sali IN STRING, nowe_id_budynku IN INTEGER) IS
--BEGIN
--    EXECUTE IMMEDIATE 'ALTER TABLE zajecia
--        DROP CONSTRAINT zajecia_sala_fk;
--    UPDATE sala
--        SET 
--            nr_sali = nowy_nr_sali
--            sala_obiekt_sportowy_id_ob = nowe_id_budynku
--        WHERE 
--            nr_sali = stary_nr_sali
--            sala_obiekt_sportowy_id_ob = stare_id_budynku';
--    UPDATE zajecia
--        SET 
--            nr_sali = nowy_nr_sali
--            sala_obiekt_sportowy_id_ob = nowe_id_budynku
--        WHERE 
--            nr_sali = stary_nr_sali
--            sala_obiekt_sportowy_id_ob = stare_id_budynku;
--    EXECUTE IMMEDIATE 'ALTER TABLE zajecia
--        ADD CONSTRAINT zajecia_sala_fk FOREIGN KEY ( sala_obiekt_sportowy_id_ob,
--        sala_nr_sali )
--        REFERENCES sala ( obiekt_sportowy_id_obiektu,
--        nr_sali )';
--END zaktualizuj_sale;
--/


CREATE INDEX wyposazenie_idx ON wyposazenie(dyscyplina);
CREATE INDEX uczestnik_oplacony_idx ON uczestnik(oplacony);
CREATE INDEX klient_idx ON klient(nazwisko, imie);
CREATE INDEX uczestnik_nazwisko_idx ON uczestnik(nazwisko, imie);
CREATE INDEX obiekt_idx ON obiekt_sportowy(nazwa);
CREATE INDEX trener_idx ON trener(dyscyplina);
CREATE INDEX zajecia_idx ON zajecia(dyscyplina);

-- indeksy poniżej zakładane automatycznie
--CREATE INDEX karnet_idx ON karnet(klient_id_klienta, zajecia_id_zajec);
--CREATE INDEX prac_idx ON pracownik(PESEL);


create SEQUENCE seq_id_obiektu minvalue 0 start with 0 increment by 1;
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.nextval, 'ul. Piotrowo 4, 61-138, Poznan', 'Centrum Sportu Politechniki Poznanskiej', 'kompleks sportowy');
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.NEXTVAL, 'ul. Piotrowo 4, 61-138, Poznan', 'Kort tenisowy 1', 'kort tenisowy');
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.NEXTVAL, 'ul. Piotrowo 4, 61-138, Poznan', 'Kort tenisowy 2', 'kort tenisowy');
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.NEXTVAL, 'ul. Piotrowo 4, 61-138, Poznan', 'Kort tenisowy 3', 'kort tenisowy');
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.NEXTVAL, 'ul. Piotrowo 4, 61-138, Poznan', 'Boisko do pilki noznej', 'boisko do pilki noznej');
insert into OBIEKT_SPORTOWY values ( SEQ_ID_OBIEKTU.NEXTVAL, 'ul. Jana Pawla II 28, 61-138, Poznan', 'Silownia DS1', 'silownia');

insert into sala values ( 'Squash 1', 1);
insert into sala values ( 'Squash 2', 1);
insert into sala values ( 'Squash 3', 1);
insert into sala values ( 'Squash 4', 1);
insert into sala values ( 'Hala sportowa', 1);
insert into sala values ( 'Silownia', 1);
insert into sala values ( 'Sala fitness', 1);
insert into sala values ( 'Kregielnia', 1);
insert into sala values ( 'Judo', 1);
insert into sala values ( 'Sala taneczna', 1);

insert into pracownik values ( '82110478194', 'Kowalski', 'Adam', 'Trener', 2000);
insert into trener values ( '82110478194', 'Squash');
insert into pracownik values ( '76071319471', 'Nowak', 'Wojciech', 'Trener', 3000);
insert into trener values ( '76071319471', 'Tenis');
insert into pracownik values ( '68063073877', 'Tomasz', 'Borski', 'Trener', 4000);
insert into trener values ( '68063073877', 'Silownia');
insert into pracownik values ( '92120107827', 'Majchrzak', 'Jan', 'Trener', 4500);
insert into trener values ( '92120107827', 'Judo');
insert into pracownik values ( '85032701923', 'Zdzislaw', 'Kmieciak', 'Trener', 3500);
insert into trener values ( '85032701923', 'Taniec towarzyski');
insert into pracownik values ( '73110189234', 'Andrzejewska', 'Anna', 'Trener', 2900);
insert into trener values ( '73110189234', 'Siatkowka');
insert into pracownik values ( '81031201242', 'Chojnacka', 'Kamila', 'Trener', 4200);
insert into trener values ( '81031201242', 'Judo');
insert into pracownik values ( '71052310923', 'Nawalka', 'Adam', 'Trener', 8000);
insert into trener values ( '71052310923', 'Pilka nozna');
insert into pracownik values ( '83071401923', 'Banaszak', 'Katarzyna', 'Trener', 3700);
insert into trener values ( '83071401923', 'Taniec towarzyski');

insert into pracownik values ( '60031874813', 'Karp','Grazyna',  'Sprzataczka', 1800);
insert into pracownik values ( '78003287311', 'Nowicka', 'Magda', 'Portierka', 1900);
insert into pracownik values ( '53022819821', 'Wasik', 'Grzegorz', 'Portier', 1900);
insert into pracownik values ( '69042712918', 'Szmyt', 'Antoni', 'Dyrektor', 10300);
insert into pracownik values ( '82120134982', 'Nowak', 'Ilona', 'Ksiegowa', 7200);

create SEQUENCE seq_id_wyposazenia minvalue 0 start with 0 increment by 1;
insert into wyposazenie values ( seq_id_wyposazenia.nextval, 'Rakiety do squasha', 'Squash', '10', 1, NULL, NULL );
insert into wyposazenie values ( seq_id_wyposazenia.nextval, 'Sprzet w silowni', NULL, NULL, NULL, 1, 'Silownia' );
insert into wyposazenie values ( seq_id_wyposazenia.nextval, 'Pilka gimnastyczna', 'Gimnastyka', 5, NULL, 1, 'Sala fitness' );

create SEQUENCE seq_id_klienta minvalue 0 start with 0 increment by 1;
insert into klient values (seq_id_klienta.nextval, 'Igor', 'Matecki');
insert into klient values (seq_id_klienta.nextval, 'Ala', 'Kolot');
insert into klient values (seq_id_klienta.nextval, 'Andrzej', 'Bakat');
insert into klient values (seq_id_klienta.nextval, 'Piotr', 'Krupa');
insert into klient values (seq_id_klienta.nextval, 'Konrad', 'Tyma');

create SEQUENCE seq_id_zajec minvalue 0 start with 0 increment by 1;
insert into zajecia values (seq_id_zajec.nextval, 'poniedzialek', to_timestamp('12:00:00','HH24:MI:SS'), to_timestamp('13:00:00','HH24:MI:SS'), 'Silownia', '30', '68063073877', NULL, 1, 'Silownia');
insert into zajecia values (seq_id_zajec.nextval, 'sroda', to_timestamp('18:00:00','HH24:MI:SS'), to_timestamp('19:00:00','HH24:MI:SS'), 'Silownia', '40', '68063073877', NULL, 1, 'Silownia');
insert into zajecia values (seq_id_zajec.nextval, 'sroda', to_timestamp('19:00:00','HH24:MI:SS'), to_timestamp('21:00:00','HH24:MI:SS'), 'Squash', '50', '82110478194', NULL, 1, 'Squash 1');
insert into zajecia values (seq_id_zajec.nextval, 'piatek', to_timestamp('18:00:00','HH24:MI:SS'), to_timestamp('20:00:00','HH24:MI:SS'), 'Squash', '50', '82110478194', NULL, 1, 'Squash 1');
insert into zajecia values (seq_id_zajec.nextval, 'wtorek', to_timestamp('9:00:00','HH24:MI:SS'), to_timestamp('11:00:00','HH24:MI:SS'), 'Tenis', '70', '76071319471', 2, NULL, NULL);
insert into zajecia values (seq_id_zajec.nextval, 'czwartek', to_timestamp('8:00:00','HH24:MI:SS'), to_timestamp('10:00:00','HH24:MI:SS'), 'Tenis', '65', NULL, 3, NULL, NULL);
insert into zajecia values (seq_id_zajec.nextval, 'czwartek', to_timestamp('8:00:00','HH24:MI:SS'), to_timestamp('10:00:00','HH24:MI:SS'), 'Tenis', '65', NULL, 3, NULL, NULL);
insert into zajecia values (seq_id_zajec.nextval, 'sobota', to_timestamp('10:00:00','HH24:MI:SS'), to_timestamp('11:00:00','HH24:MI:SS'), 'BJJ', '50', '92120107827', NULL, 1, 'Judo');

insert into zawody values('Mistrzostwa PP w Judo', TO_DATE('01-12-2018','DD-MM-YYYY'), 'Judo', 50, 1);
insert into zawody values('Mistrzostwa Swinca w Tenisie Ziemnym',TO_DATE('01-07-2019','DD-MM-YYYY'), 'Tenis', '80', 2);

insert into karnet values (4, 1, 275.50, TO_DATE('01-12-2018','DD-MM-YYYY'), TO_DATE('31-01-2019','DD-MM-YYYY'));
insert into karnet values (3, 2, 245.04, TO_DATE('01-12-2018','DD-MM-YYYY'), TO_DATE('31-01-2019','DD-MM-YYYY'));
insert into karnet values (1, 3, 210, TO_DATE('01-12-2018','DD-MM-YYYY'), TO_DATE('31-01-2019','DD-MM-YYYY'));
insert into karnet values (1, 1, 180.5, TO_DATE('01-12-2018','DD-MM-YYYY'), TO_DATE('31-01-2019','DD-MM-YYYY'));

create SEQUENCE seq_id_uczestnika minvalue 0 start with 0 increment by 1;
insert into uczestnik values (seq_id_uczestnika.nextval,'89081887811', 'Bury', 'Hubert', 0, 'Mistrzostwa PP w Judo');
insert into uczestnik values (seq_id_uczestnika.nextval,'95051387618', 'Jaki', 'Patryk', 0, 'Mistrzostwa Swinca w Tenisie Ziemnym');
insert into uczestnik values (seq_id_uczestnika.nextval,'92032384671', 'Nowy', 'Krzysztof', 1, 'Mistrzostwa PP w Judo');
insert into uczestnik values (seq_id_uczestnika.nextval,'92032382341', 'Mania', 'Jakub', 1, 'Mistrzostwa Swinca w Tenisie Ziemnym');

CREATE VIEW v_zajecia 
AS
(SELECT z.id_zajec, 
z.dzien_tygodnia, 
to_char(z.godzina_rozp,'HH24:MI') AS godz_start, 
to_char(z.godzina_zakon, 'HH24:MI') AS godz_koniec, 
z.dyscyplina, 
z.cena, 
z.trener_pesel, 
p.nazwisko, 
z.obiekt_sportowy_id_obiektu, 
z.sala_obiekt_sportowy_id_ob,
z.sala_nr_sali
FROM zajecia z
    LEFT JOIN trener t ON trener_pesel = t.PESEL 
    LEFT JOIN pracownik p ON t.PESEL = p.PESEL
);
commit; 