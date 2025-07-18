-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;

DROP TABLE IF EXISTS AuthorGroup;
DROP TABLE IF EXISTS ReviewerGroup;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS ICodeGroup;
DROP TABLE IF EXISTS Manuscript;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Editor;
DROP TABLE IF EXISTS Affiliation;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Status;
DROP TABLE  IF EXISTS RICodes;


-- tables with no foreign-key dependencies
CREATE TABLE Person (
    idPerson INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(45) NOT NULL,
    firstname VARCHAR(45) NOT NULL
);

CREATE TABLE Affiliation (
    idAffiliation INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE Status (
    idStatus INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    statusText VARCHAR(45) NOT NULL
);
-- From the provided code
CREATE TABLE    RICodes
  ( code        MEDIUMINT NOT NULL AUTO_INCREMENT,
    interest    varchar(64) NOT NULL,
    PRIMARY KEY (code)
  );
  
-- Tables that depend on Person and Affiliation
CREATE TABLE Author (
    idAuthor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    Affiliation_idAffiliation INT NOT NULL,
    Person_idPerson INT NOT NULL,
    FOREIGN KEY (Affiliation_idAffiliation) REFERENCES Affiliation(idAffiliation),
    FOREIGN KEY (Person_idPerson) REFERENCES Person(idPerson)
);

CREATE TABLE Reviewer (
    idReviewer INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    Affiliation_idAffiliation INT NOT NULL,
    Person_idPerson INT,
    FOREIGN KEY (Affiliation_idAffiliation) REFERENCES Affiliation(idAffiliation),
    FOREIGN KEY (Person_idPerson) REFERENCES Person(idPerson)
);

CREATE TABLE Editor (
    idEditor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Person_idPerson INT NOT NULL,
    FOREIGN KEY (Person_idPerson) REFERENCES Person(idPerson)
);

-- Table that depend on Status and  RICodes
CREATE TABLE Manuscript (
    idManuscripts INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    date_received DATETIME NOT NULL,
    idStatus INT,
    idICode MEDIUMINT,
    ICode_idICode MEDIUMINT,
    dateAccepted DATETIME NOT NULL,
    FOREIGN KEY (idStatus) REFERENCES Status(idStatus),
    FOREIGN KEY (idICode) REFERENCES RICodes(code),
    FOREIGN KEY (ICode_idICode) REFERENCES RICodes(code)
);

-- Tables that depend on Manuscript, Reviewer, or Author
CREATE TABLE Feedback (
    idFeedback INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    score INT NOT NULL,
    recommendation ENUM('0', '10'),
    date DATETIME NOT NULL,
    Reviewer_idReviewer INT,
    Manuscripts_idManuscripts INT,
    FOREIGN KEY (Reviewer_idReviewer) REFERENCES Reviewer(idReviewer),
    FOREIGN KEY (Manuscripts_idManuscripts) REFERENCES Manuscript(idManuscripts)
);

CREATE TABLE ReviewerGroup (
    idReviewerGroup INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Reviewer_idReviewer INT,
    Manuscripts_idManuscripts INT,
    DateAssigned DATETIME NOT NULL,
    FOREIGN KEY (Reviewer_idReviewer) REFERENCES Reviewer(idReviewer),
    FOREIGN KEY (Manuscripts_idManuscripts) REFERENCES Manuscript(idManuscripts)
);

CREATE TABLE AuthorGroup (
    idAuthorGroup INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Author_idAuthor INT,
    Manuscripts_idManuscripts INT,
    isPrimaryAuthor ENUM('yes', 'no'),
    FOREIGN KEY (Author_idAuthor) REFERENCES Author(idAuthor),
    FOREIGN KEY (Manuscripts_idManuscripts) REFERENCES Manuscript(idManuscripts)
);

CREATE TABLE ICodeGroup (
    idICodeGroup INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ICode_idICode MEDIUMINT,
    Reviewer_idReviewer INT,
    FOREIGN KEY (ICode_idICode) REFERENCES RICodes(code),
    FOREIGN KEY (Reviewer_idReviewer) REFERENCES Reviewer(idReviewer)
);

SHOW TABLES;
