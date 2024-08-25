// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedCourseReviews {
    mapping (uint => mapping (address => Review)) public courseReviews;

    mapping (address => uint) public studentTokens;

    mapping (uint => uint) public courseTokenRewards;

    event SubmitReview(address student, uint courseId, string review);
    event EarnTokens(address student, uint courseId, uint tokens);

    struct Review {
        string review;
        uint timestamp;
    }
    function submitReview(uint courseId, string memory review) public {
        require(!hasSubmittedReview(msg.sender, courseId), "Student has already submitted a review for this course");

        Review memory newReview = Review(review, block.timestamp);

        courseReviews[courseId][msg.sender] = newReview;

     
        emit SubmitReview(msg.sender, courseId, review);

        // Reward the student with tokens
        rewardStudent(msg.sender, courseId);
    }

    
    function hasSubmittedReview(address student, uint courseId) internal view returns (bool) {
    return bytes(courseReviews[courseId][student].review).length > 0;
}

    function rewardStudent(address student, uint courseId) internal {
        uint tokens = courseTokenRewards[courseId];


        studentTokens[student] += tokens;

        emit EarnTokens(student, courseId, tokens);
    }

    function setTokenReward(uint courseId, uint tokens) public {
        courseTokenRewards[courseId] = tokens;
    }


    function viewTokenBalance(address student) public view returns (uint) {
        return studentTokens[student];
    }
}
