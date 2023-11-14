CREATE TABLE registration (
    TransactionDate DATE,
    Make VARCHAR,
    Model VARCHAR,
    MYear INTEGER,
    Color VARCHAR,
    Type VARCHAR,
    Use VARCHAR,
    FuelTypePrimary VARCHAR,
    GVWRClass VARCHAR,
    GVWRRange VARCHAR,
    FuelTypeSecondary VARCHAR,
    Electrification VARCHAR,
    PlateBackground VARCHAR,
    PlateConfiguration VARCHAR,
    OwnerType VARCHAR,
    County VARCHAR,
    State VARCHAR,
    PostalCode VARCHAR,
    TransactionType VARCHAR,
    TransactionChannel VARCHAR,
    CensusTract VARCHAR,
    TransactionCount VARCHAR
);


-- The dataset has dates in MDY format; make sure that is enabled:
SET datestyle TO 'ISO, MDY';

-- assumes vrt50k.csv is in this directory:
\COPY registration FROM 'vrt50k.csv' CSV HEADER;

