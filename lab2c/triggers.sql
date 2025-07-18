-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;

CREATE TABLE IF NOT EXISTS GeneralErrorLog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    errorMessage TEXT
);


DELIMITER //

 DROP TRIGGER IF EXISTS triggerNoReviewer;
 DROP TRIGGER IF EXISTS triggerReviewerResign;
 DROP TRIGGER IF EXISTS  before_insert_manuscript;
DROP TRIGGER IF EXISTS  before_insert_person;

CREATE TRIGGER triggerNoReviewer
BEFORE INSERT ON Manuscript
FOR EACH ROW
BEGIN
    DECLARE reviewerCount INT;
    DECLARE msg VARCHAR(255);

    -- Count how many reviewers have manuscript's ICode.
    SELECT COUNT(*) INTO reviewerCount
      FROM ICodeGroup
     WHERE ICode_idICode = NEW.idICode;
     
    IF reviewerCount < 3 THEN
       SET msg = CONCAT('Not sufficient reviewers for manuscript with ICode ', NEW.idICode);
       -- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
       INSERT INTO GeneralErrorLog (errorMessage) VALUES (msg);
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER triggerReviewerResign
BEFORE DELETE ON Reviewer
FOR EACH ROW
BEGIN
    DECLARE reviewerCount INT;
    DECLARE msg VARCHAR(255);
    DECLARE manuscriptICode INT;
    DECLARE manuscriptID INT;
    
    -- Get the manuscript's ID and ICode associated with the reviewer being deleted.

SELECT 
    M.idManuscripts, M.idICode
INTO manuscriptID , manuscriptICode FROM
    Manuscript M
        JOIN
    ReviewerGroup RG ON M.idManuscripts = RG.Manuscripts_idManuscripts
WHERE
    RG.Reviewer_idReviewer = OLD.idReviewer
        AND M.idStatus = 2
LIMIT 1;
    
    -- Count how many reviewers have the same ICode that are not already assigned to this manuscript.
SELECT 
    COUNT(*)
INTO reviewerCount FROM
    ICodeGroup IG
WHERE
    IG.ICode_idICode = manuscriptICode
        AND IG.Reviewer_idReviewer NOT IN (SELECT 
            RGI.Reviewer_idReviewer
        FROM
            ReviewerGroup RGI
        WHERE
            RGI.Manuscripts_idManuscripts = manuscriptID);
    
    IF reviewerCount = 0 THEN
       -- 	If there are no available reviewers: mark the manuscript as rejected.
       UPDATE Manuscript
         SET idStatus = 4
         WHERE idManuscripts = manuscriptID;
       
       SET msg = CONCAT('Manuscript with ICode ', manuscriptICode, 
                        ' rejected due to no available reviewers.');
	    INSERT INTO GeneralErrorLog (errorMessage) VALUES (msg);
	   -- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    ELSE
       -- Otherwise, mark the manuscript as submitted.
       UPDATE Manuscript
         SET idStatus = 1
         WHERE idManuscripts = manuscriptID;
    END IF;
END;
//

DELIMITER ;

-- before insert person trigger  
DELIMITER //
CREATE TRIGGER before_insert_person
BEFORE INSERT ON Person
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    -- Check for invalid firstname or lastname
    IF NEW.firstname IS NULL 
       OR NEW.lastname IS NULL THEN
       SET msg = CONCAT('Invalid data: Firstname or Lastname cannot be empty');

       INSERT INTO GeneralErrorLog (errorMessage) 
       VALUES (msg);
  --  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
//

DELIMITER ;

-- before insert manuscript trigger 
DELIMITER //
CREATE TRIGGER before_insert_manuscript
BEFORE INSERT ON Manuscript
FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    -- Check for NULL or empty values
    IF NEW.title IS NULL 
       OR NEW.idICode IS NULL OR NEW.idICode <= 0 THEN
       SET msg = CONCAT( 'Title or ICode cannot be empty');
       INSERT INTO GeneralErrorLog (errorMessage) 
       VALUES ( msg);
    --    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
//

DELIMITER ;



SHOW TRIGGERS IN F006BXT_db;
