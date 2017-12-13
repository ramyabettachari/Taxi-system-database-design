--when inserting or updating an employee, switch availability to “Y” if startTime < currentTime < endTime. Otherwise, switch to “N”.
CREATE OR REPLACE TRIGGER SetAvailibility
BEFORE INSERT OR UPDATE ON Driver
FOR EACH ROW
DECLARE
	currentHour number;
	currentMin number;
	startHourC char(2);
	startMinC char(2);
	endHourC char(2);
	endMinC char(2);
	startHour number;
	startMin number;
	endHour number;
	endMin number;
	available Driver.Status%TYPE;
  drvrSsn Driver.Ssn%TYPE;
  startTime Employee.Start_Time%TYPE;
  endTime Employee.End_Time%TYPE;
BEGIN  
	currentHour := to_number(to_char(sysdate, 'hh24'));
	currentMin := to_number(to_char(sysdate, 'mi'));
  
  drvrSsn := :new.Ssn;
  SELECT Start_Time INTO startTime FROM Employee WHERE Ssn = drvrSsn;
  SELECT End_Time INTO endTime FROM Employee WHERE Ssn = drvrSsn;
  
	startHourC := SUBSTR(startTime, 1, 2);
	startHour := to_number(startHourC);
	startMinC := SUBSTR(startTime, 4, 5);
	startMin := to_number(startMinC);
  
	endHourC := SUBSTR(endTime, 1, 2);
	endHour := to_number(endHourC);
	endMinC := SUBSTR(endTime, 4, 5);
	endMin := to_number(endMinC);
  
	available := 'N';
	IF startHour <= currentHour AND startMin <= currentMin THEN
		IF currentHour <= endHour AND currentMin <= endMIN THEN
			available := 'Y';
		END IF;
	END IF;
  
  :new.Status := available;
END;
/
