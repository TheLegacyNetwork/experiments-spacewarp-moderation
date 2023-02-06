// LEGACY Network moderation actor

pragma solidity ^0.8.0;

/*
This actor is a work in progress, and is not yet ready for production use.
It is provided as a reference implementation for the LEGACY Network, where the actor will receive
a contentId in the form of the content hash (cid), then calculate a risk score based on how many times
this has been flagged in the past, and how recently it was flagged. Returning the risk score in the
request for evaluation.

A future implementation of this would be as part of a longer moderation process requiring a DAO to vote
on moderation requirements, and then a second actor to actually perform the moderation either removing the
moderation request itself or disabling/expiring the storage deal of the content where required (In the case
where there are legal requirements)
*/

contract ModerationActor {
    mapping (bytes32 => uint) public moderationCounts;
    mapping (bytes32 => uint) public moderationDates;
    mapping (bytes32 => uint) public moderationRisks;

    function incrementModerationCount(bytes32 contentId) public {
        moderationCounts[contentId]++;
        moderationDates[contentId] = now;
    }

    function calculateRiskScore(bytes32 contentId) public view returns (uint) {
        uint count = moderationCounts[contentId];
        uint date = moderationDates[contentId];
        uint hour = 1 hours;
        uint day = 24 hours;
        uint week = 7 days;
        uint score;

        if (count >= 10 && (now - date) <= hour) {
            score = 10;
        } else if (count >= 100 && (now - date) <= day) {
            score = 100;
        } else if (count >= 1000 && (now - date) <= week) {
            score = 1000;
        } else {
            score = 0;
        }

        moderationRisks[contentId] = score;
        return score;
    }
}
