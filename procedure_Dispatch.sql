--check driver’s current availability and assigns driver and taxi to ride request thereby creating tables in ride table. Then updates driver’s and taxi’s availability

CREATE OR REPLACE PROCEDURE
DISPATCH AS
CURSOR cursor_ride_request IS
SELECT * FROM RIDE_REQUEST RR where STATUS IN ('ACTIVE','PENDING') FOR UPDATE;
thisRequest cursor_ride_request%ROWTYPE;
Driver_ssn decimal(9,0);
vehicle_number VARCHAR(10);
Count_driver INTEGER;
Count_taxi INTEGER;
BEGIN
  OPEN cursor_ride_request;
  LOOP
    FETCH cursor_ride_request INTO thisRequest;
    EXIT WHEN (cursor_ride_request%NOTFOUND);
    SELECT COUNT(*) into Count_driver FROM DRIVER 
        where STATUS = 'Y' and ROWNUM = 1;
    SELECT COUNT(*) INTO Count_taxi FROM TAXI T, TAXI_MODEL TM
        where T.modelType = TM.modelType and NO_OF_SEATS >=THISREQUEST.NO_OF_PASSENGERS AND WHEEL_CHAIR_ACCESS = thisRequest.WHEEL_CHAIR_ACCESS AND STATUS = 'Y' and ROWNUM = 1;
    IF Count_driver > 0 AND Count_taxi > 0 THEN
      SELECT ssn  into Driver_ssn FROM DRIVER 
        where STATUS = 'Y' and ROWNUM = 1;
      SELECT VEHICLE_NO INTO VEHICLE_NUMBER FROM TAXI T, TAXI_MODEL TM
        where T.modelType = TM.modelType and NO_OF_SEATS >=THISREQUEST.NO_OF_PASSENGERS AND STATUS = 'Y' and ROWNUM = 1;
      UPDATE RIDE_REQUEST SET STATUS = 'ACCEPTED'
      WHERE CURRENT OF cursor_ride_request;
      UPDATE driver SET STATUS = 'N' WHERE SSN=DRIVER_SSN;
      UPDATE TAXI SET STATUS = 'N' WHERE VEHICLE_NO = VEHICLE_NUMBER;
      INSERT INTO RIDE VALUES(thisRequest.REQUEST_ID, Driver_ssn, vehicle_number, SYSDATE, NULL, NULL);
      dbms_output.put_line('Request no '||thisRequest.request_id||' has been accepted');
    ELSE
      UPDATE RIDE_REQUEST SET STATUS = 'PENDING'
      WHERE CURRENT OF cursor_ride_request; 
      dbms_output.put_line('Request no '||thisRequest.request_id||' is pending as none of the drivers/Taxis are available at the moment');
    END IF;  
END LOOP;
CLOSE cursor_ride_request;
END;
.
RUN;


set serveroutput on
begin
dispatch;
end;
