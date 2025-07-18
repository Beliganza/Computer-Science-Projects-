-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;
SET @minScore = 5;
DROP PROCEDURE IF EXISTS MakeDecision;

DELIMITER //

CREATE PROCEDURE MakeDecision(
    IN manuscriptID INT,
    OUT decision VARCHAR(255)
)

BEGIN
    DECLARE avgScore DECIMAL(10,4);
    DECLARE manuscript_number INT;

    -- Check if the manuscript exists.
    SET manuscripts_found = (SELECT COUNT(*) FROM Manuscript WHERE idManuscripts = manuscriptID);

    IF manuscripts_found = 0 THEN
        SET decision = CONCAT('Manuscript with ID ', manuscriptID, ' does not exist.');
    END IF;

    -- Calculate the average score for the given manuscript.
    SELECT AVG(score) INTO avgScore
    FROM Feedback
    WHERE Manuscripts_idManuscripts = manuscriptID;

    -- Check if the manuscript should be accepted or rejected.
    IF avgScore >= @minScore THEN
        -- Accept the manuscript.
        UPDATE Manuscript
        SET idStatus = 3 
        WHERE idManuscripts = manuscriptID;
        SET decision = CONCAT('Manuscript ', manuscriptID, ' accepted with average score ', avgScore);
        
    ELSE
        -- Reject the manuscript.
        UPDATE Manuscript
        SET idStatus = 4 
        WHERE idManuscripts = manuscriptID;
        SET decision = CONCAT('Manuscript ', manuscriptID, ' rejected with average score ', avgScore);
        
    END IF;
END;
//

DELIMITER ;

