-- Author; Ganza Belise 
-- Date: February 10th 2025 

-- Invalid data tests 
USE F006BXT_db;

-- inserting a Person with NULL values for NOT NULL columns 
INSERT INTO Person (idPerson, lastname, firstname) VALUES (NULL, NULL, 'John'); -- -- should trigger an error 

-- Attempt to insert an Affiliation with a NULL description. 
INSERT INTO Affiliation (idAffiliation, description) VALUES (NULL, NULL);  -- should trigger an error 

INSERT INTO Person (lastname, firstname)
VALUES ('kaylor', ''); -- Should trigger an error and log it

INSERT INTO Manuscript (title, date_received, idStatus, idICode, ICode_idICode, dateAccepted)
VALUES ('', NULL, 1, NULL, NULL, '2024-01-20'); -- Should trigger an error and log it


-- Attempt to insert a Manuscript with an invalid idStatus (should fail)
INSERT INTO Manuscript (title, date_received, idStatus, idICode, ICode_idICode, dateAccepted)
VALUES ('Climate engineering 101', '2024-01-15', 45, 2, 2, '2024-01-16');

