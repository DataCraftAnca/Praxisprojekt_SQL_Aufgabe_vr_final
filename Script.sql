

CREATE TABLE kategorie (
    kategorieid SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE produkt (
    produktid SERIAL PRIMARY KEY,
    name VARCHAR(255),
    preis DECIMAL,
    kategorieid INTEGER REFERENCES kategorie(kategorieid)
);

CREATE TABLE kunden (
    kundenid SERIAL PRIMARY KEY,
    name VARCHAR(255),
    adresse VARCHAR(255),
    kreditkarte VARCHAR(16)
);

CREATE TABLE bestellung (
    bestellid SERIAL PRIMARY KEY,
    kundenid INTEGER REFERENCES kunden(kundenid),
    produktid INTEGER REFERENCES produkt(produktid),
    menge INTEGER,
    bestelldatum DATE
);
    
    select * from bestellung;
   
   select * from kategorie k;
  
  select * from kunden;
 
 select * from produkt;
);



CREATE ROLE data_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO data_analyst;
--REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM data_analyst;
GRANT USAGE ON SCHEMA public TO data_analyst;
GRANT ALL privileges on all tables IN SCHEMA public TO data_analyst;


CREATE ROLE callcenter_mitarbeiter;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO callcenter_mitarbeiter;
--REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM callcenter-mitarbeiter;
GRANT USAGE ON SCHEMA public TO callcenter_mitarbeiter;
GRANT ALL privileges on all tables IN SCHEMA public TO callcenter_mitarbeiter;

CREATE user mitarbeiter_1 with password '1234';
create user mitarbeiter_2 with password '4321';

grant callcenter_mitarbeiter to mitarbeiter_1;
grant data_analyst to mitarbeiter_2;

CREATE VIEW Kunden_Ansicht AS
SELECT kundenID, name, adresse, '***' || right(kreditkarte, 3) AS kreditkarte
FROM Kunden;

select * from kunden_ansicht;
GRANT SELECT ON Kunden_Ansicht TO data_analyst;
SELECT * FROM Kunden_Ansicht;

CREATE VIEW Bestellungen_Ansicht AS
SELECT bestellid, kundenid, bestelldatum, menge
FROM bestellung;
GRANT SELECT ON Bestellungen_Ansicht TO callcenter_mitarbeiter;


SELECT name, MAX(preis) AS max_payment
FROM produkt
GROUP BY name
ORDER BY max_payment DESC
LIMIT 1;

SELECT kundenid, MAX(menge) AS max_menge
FROM bestellung
GROUP BY kundenid
ORDER BY max_menge DESC
LIMIT 1;

select produktid, max(preis) as max_payment
from produkt
join bestellung using (produktid)
group by produktid
order by max(menge) desc 
limit 1;

SELECT b.KundenID, k.Name, SUM(b.Menge * p.Preis) AS Gesamtbetrag
FROM bestellung b
JOIN kunden k ON b.KundenID = k.KundenID
JOIN produkt p ON b.ProduktID = p.ProduktID
GROUP BY b.KundenID, k.Name
ORDER BY Gesamtbetrag DESC
LIMIT 1
