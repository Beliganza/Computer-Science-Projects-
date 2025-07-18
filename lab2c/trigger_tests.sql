-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;

TRUNCATE TABLE GeneralErrorLog;

-- Insert a test manuscript with ICode 2. Should not trigger an error since it has enough reviewers 
INSERT INTO Manuscript (title, date_received, idStatus, idICode, ICode_idICode, dateAccepted)
VALUES ('Climate engineering 101', '2024-01-15', 1, 2, 2, '2024-01-16');
SELECT title, idStatus 
FROM Manuscript 
WHERE title = 'Climate engineering 101';


 -- test manuscript with ICode 3. Should raise an error since it doesn't have enough reviewers
INSERT INTO Manuscript (title, date_received, idStatus, idICode, ICode_idICode, dateAccepted)
VALUES ('Advanced Agricultural Engineering', '2024-01-20', 1, 3, 3, '2024-01-21');
-- Confirm that the manuscript was not inserted.
SELECT title, idStatus
FROM Manuscript 
WHERE title = 'Advanced Agricultural Engineering';


-- Delete the reviewer for Manuscript with Icode one, status should change to submitted since it doesn't have enough reviewers 
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Reviewer WHERE idReviewer = 1;
SET FOREIGN_KEY_CHECKS = 1;
-- Confirm that the manuscript's status is now updated to Rejected (idStatus = 4).
SELECT title, idStatus 
FROM Manuscript 
WHERE title = 'AI in Medicine';    

-- Manuscript is Reset to "Submitted" 
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Reviewer WHERE idReviewer = 2;
SET FOREIGN_KEY_CHECKS = 1;
-- Check if the manuscript status changed to "submitted"
SELECT title, idStatus 
FROM Manuscript 
WHERE title = 'Deep Learning Applications';


-- Manuscript is Rejected 
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Reviewer WHERE idReviewer = 3;
SET FOREIGN_KEY_CHECKS = 1;
-- Check if the manuscript status changed to "rejected"
SELECT title, idStatus 
FROM Manuscript 
WHERE title = 'Big Data Analytics';

-- Check if the exception messages are logged
SELECT  * FROM GeneralErrorLog;

