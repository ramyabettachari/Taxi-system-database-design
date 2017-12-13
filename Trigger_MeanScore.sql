--update a driver’s mean score after a new review is written for him or her
CREATE OR REPLACE TRIGGER MeanScore
AFTER INSERT OR UPDATE ON Review
FOR EACH ROW
DECLARE
	previousScores Driver.Average_Score%TYPE;
  newScore Review.Score%Type;
	meanScore Driver.Average_Score%TYPE;
  updatedDrvrSsn Review.Driver_Ssn%TYPE;
  numReviews Driver.NumOfReviews%TYPE;
BEGIN
  updatedDrvrSsn := :new.Driver_Ssn;
  
	SELECT NumOfReviews INTO numReviews FROM Driver WHERE Ssn = updatedDrvrSsn;
  numReviews := numReviews+1;
  UPDATE Driver SET NumOfReviews = numReviews WHERE Ssn = updatedDrvrSsn;
  
  newScore := :new.Score;
	SELECT Average_score INTO previousScores FROM Driver WHERE Ssn = updatedDrvrSsn;
  IF previousScores IS NULL THEN
    meanScore := newScore;
  ELSE
    meanScore := newScore/numReviews + previousScores*(numReviews-1)/numReviews;
  END IF;
  UPDATE Driver SET Average_Score = meanScore WHERE Ssn = updatedDrvrSsn;
END;
/
