ALTER TABLE PMS_PREMISES
ADD DECORATION guidenamenull

ALTER TABLE PMS_PREMISES
ADD GLASSY guidenamenull

ALTER TABLE PMS_PREMISES
ADD BLOCK_SECTION guidenamenull

ALTER TABLE PMS_PREMISES
ADD PRICE2 MONEY

UPDATE PMS_PREMISES
SET PRICE2=price/GENERALAREA
WHERE TYPEOPERATION=2

SELECT PRICE, GENERALAREA, PRICE2 FROM PMS_PREMISES
WHERE TYPEOPERATION=2


