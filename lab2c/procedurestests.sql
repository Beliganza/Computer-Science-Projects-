
-- Author; Ganza Belise 
-- Date: February 10th 2025 

USE F006BXT_db;

SET @decisionMsg = '';
CALL MakeDecision(1, @decisionMsg);
SELECT @decisionMsg;  -- Expected: "Manuscript 1 accepted with average score 7.0"

SET @decisionMsg = '';
CALL MakeDecision(2, @decisionMsg);
SELECT @decisionMsg;  -- Expected: "Manuscript 2 accepted with average score 7.5"

SET @decisionMsg = '';
CALL MakeDecision(3, @decisionMsg);
SELECT @decisionMsg;  -- Expected: "Manuscript 3 rejected with average score 4.0"

SET @decisionMsg = '';
CALL MakeDecision(4, @decisionMsg);
SELECT @decisionMsg;  -- Expected: "Manuscript 4 rejected with average score 3.0"

SET @decisionMsg = '';
CALL MakeDecision(5, @decisionMsg);
SELECT @decisionMsg;  -- Expected: "Manuscript 5 accepted with average score 9.0"

SET @decisionMsg = '';
CALL MakeDecision(99, @decisionMsg);   -- Expected: "Manuscript with ID 99 does not exist"
SELECT @decisionMsg;
