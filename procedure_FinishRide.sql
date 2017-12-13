--When ride finishes - Calculate Ride Cost and assigns end time to Ride, and updates driver’s and taxi’s availability

CREATE OR REPLACE PROCEDURE FINISH_RIDE(RIDE_REQ_ID IN RIDE.Request_ID%TYPE, END_DATE IN RIDE.End_date%TYPE, DISTANCE IN RIDE.Distance%TYPE) IS
thisPrice_rate TAXI_MODEL.Price_rate%TYPE;
thisStmt VARCHAR(500);
dist decimal(5,3);
BEGIN
dbms_output.put_line(RIDE_REQ_ID);
dbms_output.put_line(END_DATE);
dbms_output.put_line(DISTANCE);

SELECT Price_rate INTO thisPrice_rate FROM TAXI_MODEL WHERE modelType=(SELECT modelType FROM TAXI WHERE VEHICLE_NO=(SELECT Vehicle_No FROM RIDE WHERE Request_ID=RIDE_REQ_ID));
thisPrice_rate:=thisPrice_rate*DISTANCE;
dist := DISTANCE;
dbms_output.put_line(thisPrice_rate);
--print ride_cost
UPDATE DRIVER SET Status='Y' WHERE Ssn=(SELECT Ssn FROM RIDE WHERE Request_ID=RIDE_REQ_ID);
UPDATE TAXI SET Status='Y' WHERE Vehicle_no=(SELECT Vehicle_no FROM RIDE WHERE Request_ID=RIDE_REQ_ID);
--dbms_output.put_line('UPDATE RIDE SET End_date='||''''||END_DATE||''''||', Distance='||DISTANCE||' WHERE Request_ID='||''''||RIDE_REQ_ID||'''');
thisStmt := 'UPDATE RIDE SET End_date='||''''||END_DATE||''''||', Distance='||dist||' , Ride_Cost= '||thisPrice_rate||' WHERE Request_ID='||''''||RIDE_REQ_ID||'''';
dbms_output.put_line(thisStmt);
execute immediate thisStmt;
END;
/

--- Execute statement
set Serveroutput On
DECLARE
   ride_id VARCHAR(10);
   dist RIDE.Distance%TYPE;
   e_date date;
BEGIN
    ride_id :='r123456789';
    dist := 12.22;
    e_date :='22-APR-2016';
    FINISH_RIDE(ride_id,e_date, dist);
END;
