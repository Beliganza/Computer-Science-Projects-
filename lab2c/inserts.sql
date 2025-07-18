USE F006BXT_db;

-- Author; Ganza Belise 
-- Date: February 10th 2025 


-- Insert data into Person 
INSERT INTO Person (lastname, firstname)
VALUES 
    ('Ganza', 'Belise'),     
    ('Ivy', 'Wambui'),         
    ('Brown', 'Chris'),        
    ('Destin', 'Williams'),    
    ('Aloys', 'Lucide'),       
    ('Ncube', 'Tariro'),    
    ('Diop', 'Moussa'),       
    ('Adegoke', 'Funmi'),     
    ('Mutiso', 'Mwangi'),     
    ('Ama', 'Kwesi'),        
    ('Nkrumah', 'Abena'),     
    ('Ankrah', 'Kofi'),       
    ('Asante', 'Adwoa'),     
    ('Hackman', 'Ebo'),      
    ('Kabiri', 'Afua'),      
    ('Akwa', 'Yaw'),           
    ('Hawa', 'shabazz'),       
    ('Lewis', 'Santo'),
    ('Mensah', 'Kwame'),        
    ('Boateng', 'Ama'),
    ('Owusu', 'Yaw');
SELECT * FROM Person;


-- Insert data into Affiliation 
INSERT INTO Affiliation (description) 
VALUES 
    ('Harvard University'),   
    ('MIT'),                  
    ('Stanford University'),  
    ('Oxford University');    
SELECT * FROM Affiliation;

-- Insert data into Status 
INSERT INTO Status (statusText) 
VALUES 
    ('Submitted'),   
    ('Under Review'), 
    ('Accepted'),     
    ('Rejected');    
SELECT * FROM Status;

-- Insert data into RICodes 
INSERT INTO RICodes (interest) 
VALUES
    ('Agricultural engineering'),  --  1
    ('Food engineering'),          -- 2
    ('Bioprocess engineering'),      -- 3
    ('Genetic engineering'),         -- 4
    ('Human genetic engineering'),   -- 5
    ('Metabolic engineering'),       -- 6
    ('Molecular engineering');       -- 7
SELECT * FROM RICodes LIMIT 0, 1000;

-- Insert data into Author 
INSERT INTO Author (email, Affiliation_idAffiliation, Person_idPerson) 
VALUES 
    ('belise.ganza@gmail.com', 1, 1),  
    ('wambui.ivy@gmail.com', 1, 2),     
    ('chris.brown@gmail.com', 2, 3),    
    ('williams.destin@gmail.com', 2, 4),   
    ('lucide.aloys@gmail.com', 3, 5),      
    ('tariro.ncube@gmail.com', 3, 6),      
    ('moussa.diop@gmail.com', 4, 7),       
    ('funmi.adegoke@gmail.com', 4, 8),     
    ('mwangi.mutiso@gmail.com', 1, 9),   
	('kwame.mensah@gmail.com', 1, 19),    
    ('ama.boateng@gmail.com', 2, 20);
SELECT * FROM Author;


-- Insert data into Reviewer
INSERT INTO Reviewer (email, Affiliation_idAffiliation, Person_idPerson) 
VALUES 
    ('kwesi.ama@gmail.com', 1, 10),      
    ('abena.nkrumah@gmail.com', 2, 11),  
    ('kofi.ankrah@gmail.com', 3, 12),     
    ('adwoa.asante@gmail.com', 4, 13),     
    ('ebo.hackman@gmail.com', 1, 14),     
    ('afua.kabiri@gmail.com', 2, 15),     
    ('yaw.akwa@gmail.com', 3, 16),    
	('john.owusu@gmail.com', 4, 21); 
SELECT * FROM Reviewer;

-- Insert data into Editor 
INSERT INTO Editor (Person_idPerson) 
VALUES 
    (17),
    (18);
SELECT * FROM Editor;

-- Insert data into Manuscript 
INSERT INTO Manuscript (title, date_received, idStatus, idICode, ICode_idICode, dateAccepted) 
VALUES 
    ('AI in Medicine', '2024-01-01', 4, 1, 1, '2024-02-20'),         -- ICode 1: Only Reviewer 1 => Rejected
    ('Deep Learning Applications', '2024-01-15', 2, 2, 2, '2024-02-20'), -- ICode 2: Reviewers 2,3,4,5 exist => Under Review
    ('Big Data Analytics', '2024-02-01', 4, 3, 3, '2024-02-20'),         -- ICode 3: Only Reviewer 3 => Rejected
    ('Neural Networks', '2024-02-10', 2, 4, 4, '2024-02-20'),            -- ICode 4: Reviewers 4,5,6 exist => Under Review
    ('Quantum Computing Breakthrough', '2024-03-01', 4, 5, 5, '2024-03-20'), -- ICode 5: Only Reviewer 5 => Rejected
    ('Genome Editing Advances', '2024-03-05', 2, 6, 6, '2024-03-25'),          -- ICode 6: Reviewers 6,2,3,5,4 exist => Under Review
    ('Renewable Energy Systems', '2024-03-10', 4, 1, 1, '2024-03-30'),           -- ICode 1: Only Reviewer 1 => Rejected
    ('Virtual Reality in Education', '2024-03-15', 2, 2, 2, '2024-04-01');       -- ICode 2: Under Review
    
SELECT * FROM Manuscript;

-- Insert data into Feedback 
INSERT INTO Feedback (score, recommendation, date, Reviewer_idReviewer, Manuscripts_idManuscripts) 
VALUES 
    (5, '0', '2024-02-05', 1, 1),
    (7, '10', '2024-02-08', 2, 2),
    (4, '0', '2024-02-12', 3, 3), 
    (3, '0', '2024-02-15', 4, 4),
    (9, '10', '2024-03-22', 5, 5),
    (3, '0', '2024-03-27', 6, 6),
    (8, '10', '2024-03-31', 7, 7),
    (2, '0', '2024-04-02', 2, 8),
    (9, '10', '2024-02-06', 2, 1),
    (8, '10', '2024-02-10', 8, 2); 
SELECT * FROM Feedback;

-- Insert data into ReviewerGroup 
INSERT INTO ReviewerGroup (Reviewer_idReviewer, Manuscripts_idManuscripts, DateAssigned) 
VALUES 
    (1, 1, '2024-02-02'),
    (2, 2, '2024-02-06'),
    (3, 3, '2024-02-10'),
    (4, 4, '2024-02-14'),
    (5, 5, '2024-03-16'),
    (6, 6, '2024-03-17'),
    (7, 7, '2024-03-18'),
    (1, 8, '2024-03-19'),
    (8, 2, '2024-02-07');
SELECT * FROM ReviewerGroup;

-- Insert data into AuthorGroup 
INSERT INTO AuthorGroup (Author_idAuthor, Manuscripts_idManuscripts, isPrimaryAuthor) 
VALUES 
    (1, 1, 'yes'),
    (2, 1, 'no'),
    (3, 2, 'yes'),
    (4, 2, 'no'),
    (5, 3, 'yes'),
    (6, 3, 'no'),
    (7, 4, 'yes'),
    (8, 4, 'no'),
    (1, 5, 'yes'),
    (2, 6, 'yes'),
    (3, 7, 'yes'),
    (4, 8, 'yes'),
    (9, 8, 'no'),
    (10, 2, 'no'); 
SELECT * FROM AuthorGroup;

-- Insert data into ICodeGroup 
INSERT INTO ICodeGroup (ICode_idICode, Reviewer_idReviewer) 
VALUES 
    (1, 1),             -- ICode 1: only Reviewer 1
    (2, 2),             -- ICode 2: Reviewer 2
    (2, 3),             -- ICode 2: Reviewer 3
    (2, 4),             -- ICode 2: Reviewer 4
    (2, 5),             -- ICode 2: Reviewer 5
    (3, 3),             -- ICode 3: only Reviewer 3
    (4, 4),             -- ICode 4: Reviewer 4
    (4, 5),             -- ICode 4: Reviewer 5
    (4, 6),             -- ICode 4: Reviewer 6
    (5, 5),             -- ICode 5: only Reviewer 5
    (6, 6),             -- ICode 6: Reviewer 6
    (6, 2),             -- ICode 6: Reviewer 2
    (6, 3),             -- ICode 6: Reviewer 3
    (7, 7);             -- ICode 7: only Reviewer 7

SELECT * FROM ICodeGroup;
