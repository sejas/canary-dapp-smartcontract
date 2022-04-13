// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

contract Canary {
    event AddTweet(address recipient, uint256 tweetId);
    event DeleteTweet(uint256 tweetId, bool isDeleted);
    event LikedTweet(address enthusiast, uint256 tweetId);

    struct Tweet {
        uint256 id;
        address owner;
        string tweetText;
        bool isDeleted;
        uint32 likes;
        uint256 timestamp;
    }

    Tweet[] private tweets;

    // Mapping of Tweet id to the wallet address of the user
    mapping(uint256 => address) tweetToOwner;
    // mapping(uint256 => address[]) tweetToLikes;
    mapping(address => uint256[]) addressToTweetsLiked;

    // Method to be called by our frontend when trying to add a new Tweet
    function addTweet(string memory tweetText) external {
        uint256 tweetId = tweets.length;
        tweets.push(
            Tweet(tweetId, msg.sender, tweetText, false, 0, block.timestamp)
        );
        tweetToOwner[tweetId] = msg.sender;
        emit AddTweet(msg.sender, tweetId);
    }

    // Method to get one single Tweet
    function getTweet(uint256 tweetId) external view returns (Tweet memory) {
        return tweets[tweetId];
    }

    // Method to get all the Tweets
    function getAllTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < tweets.length; i++) {
            if (tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // Method to get only your Tweets
    function getMyTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](tweets.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < tweets.length; i++) {
            if (tweetToOwner[i] == msg.sender && tweets[i].isDeleted == false) {
                temporary[counter] = tweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // Method to get only your Tweets
    function getMyLikes() external view returns (Tweet[] memory) {
        uint256[] memory tweetsLiked = addressToTweetsLiked[msg.sender];
        Tweet[] memory result = new Tweet[](tweetsLiked.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < tweetsLiked.length; i++) {
            result[counter] = tweets[tweetsLiked[i]];
            counter++;
        }
        return result;
    }

    // Like tweet
    function likeTweet(uint256 tweetId) external {
        uint256[] memory tweetsLiked = addressToTweetsLiked[msg.sender];
        for (uint256 i = 0; i < tweetsLiked.length; i++) {
            if (tweetsLiked[i] == tweetId) {
                revert("You have already liked this tweet");
            }
        }
        tweets[tweetId].likes = tweets[tweetId].likes + 1;
        // tweetToLikes[tweetId].push(msg.sender);
        addressToTweetsLiked[msg.sender].push(tweetId);
        emit LikedTweet(msg.sender, tweetId);
    }

    // Method to Delete a Tweet
    function deleteTweet(uint256 tweetId, bool isDeleted) external {
        if (tweetToOwner[tweetId] == msg.sender) {
            tweets[tweetId].isDeleted = isDeleted;
            emit DeleteTweet(tweetId, isDeleted);
        }
    }
}
