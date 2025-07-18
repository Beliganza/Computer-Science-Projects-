
-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;

-- LeadAuthorManuscripts

CREATE OR REPLACE VIEW LeadAuthorManuscripts AS
SELECT 
    Person.lastname AS AuthorLastName,
    Author.idAuthor,
    Manuscript.idManuscripts AS ManuscriptID,
    Status.statusText AS CurrentStatus,
    Manuscript.date_received AS StatusChangeTimestamp
FROM Author
JOIN Person ON Author.Person_idPerson = Person.idPerson
JOIN AuthorGroup ON Author.idAuthor = AuthorGroup.Author_idAuthor
JOIN Manuscript ON AuthorGroup.Manuscripts_idManuscripts = Manuscript.idManuscripts
JOIN Status ON Manuscript.idStatus = Status.idStatus
WHERE AuthorGroup.isPrimaryAuthor = 'yes'
ORDER BY Person.lastname, Author.idAuthor, Manuscript.date_received;

DESC LeadAuthorManuscripts;
SELECT AuthorLastName, idAuthor, ManuscriptID, CurrentStatus, StatusChangeTimestamp 
FROM LeadAuthorManuscripts;

-- AnyAuthorManuscripts View 

CREATE OR REPLACE VIEW AnyAuthorManuscripts AS
SELECT 
	CONCAT(Person.firstname, ' ', Person.lastname) AS AuthorName,
	Author.idAuthor,
	Manuscript.idManuscripts AS ManuscriptID,
	Status.statusText AS ManuscriptStatus,
	Manuscript.date_received AS StatusChangeTimestamp
FROM Author
JOIN Person ON Author.Person_idPerson = Person.idPerson
JOIN AuthorGroup ON Author.idAuthor = AuthorGroup.Author_idAuthor
JOIN Manuscript ON AuthorGroup.Manuscripts_idManuscripts = Manuscript.idManuscripts
JOIN Status ON Manuscript.idStatus = Status.idStatus
ORDER BY Person.lastname, Manuscript.date_received;

DESC AnyAuthorManuscripts;
SELECT AuthorName, idAuthor, ManuscriptID, ManuscriptStatus, StatusChangeTimestamp 
FROM AnyAuthorManuscripts;


--  ReviewQueue View

CREATE OR REPLACE VIEW ReviewQueue AS
SELECT 
	CONCAT(Person.firstname, ' ', Person.lastname) AS PrimaryAuthor,
	Author.idAuthor AS AuthorID,
	Manuscript.idManuscripts AS ManuscriptID,
	ReviewerGroup.Reviewer_idReviewer AS AssignedReviewerID,
	Manuscript.date_received AS SubmissionTimestamp
FROM Manuscript
JOIN Status ON Manuscript.idStatus = Status.idStatus
JOIN AuthorGroup ON Manuscript.idManuscripts = AuthorGroup.Manuscripts_idManuscripts
JOIN Author ON AuthorGroup.Author_idAuthor = Author.idAuthor
JOIN Person ON Author.Person_idPerson = Person.idPerson
JOIN ReviewerGroup ON Manuscript.idManuscripts = ReviewerGroup.Manuscripts_idManuscripts
WHERE Status.statusText = 'Under Review'
	AND AuthorGroup.isPrimaryAuthor = 'yes'
ORDER BY Manuscript.date_received;

DESC ReviewQueue;
SELECT PrimaryAuthor, AuthorID, ManuscriptID, AssignedReviewerID, SubmissionTimestamp  
FROM ReviewQueue;

--  ReviewStatus View

CREATE OR REPLACE VIEW ReviewStatus AS
SELECT 
	ReviewerGroup.DateAssigned AS SubmissionTimestamp,
	Manuscript.idManuscripts AS ManuscriptID,
	Manuscript.title AS ManuscriptTitle,
	Feedback.score AS TotalScore,
	Feedback.recommendation AS Recommendation
FROM Feedback
JOIN ReviewerGroup ON Feedback.Manuscripts_idManuscripts = ReviewerGroup.Manuscripts_idManuscripts
JOIN Manuscript ON Feedback.Manuscripts_idManuscripts = Manuscript.idManuscripts
ORDER BY Manuscript.date_received;

DESC ReviewStatus;
SELECT SubmissionTimestamp, ManuscriptID, ManuscriptTitle, TotalScore, Recommendation  
FROM ReviewStatus;

SHOW FULL TABLES WHERE Table_type = 'VIEW';



