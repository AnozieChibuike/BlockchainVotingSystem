// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public immutable admin;
    bool public votingOpen;
    uint public votingStartTime;
    uint public votingEndTime;

    struct Candidate {
        uint id;
        string name;
        string imageUrl;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint vote;
    }

    mapping(address => Voter) public voters;
    mapping(address => bool) public registeredVoters;
    mapping(string => bool) private candidateExists;
    Candidate[] private candidates;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier votingActive() {
        require(votingOpen, "Voting is not active");
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting is outside the allowed timeframe");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(registeredVoters[msg.sender], "You are not a registered voter");
        _;
    }

    event CandidateAdded(string name, uint id);
    event VoterRegistered(address voter);
    event Voted(address indexed voter, uint indexed candidateId);
    event VotingEnded();

    constructor(uint _votingStartTime, uint _votingEndTime) {
        require(_votingEndTime > _votingStartTime, "Voting end time must be later than start time");
        admin = msg.sender;
        votingOpen = true;
        votingStartTime = _votingStartTime;
        votingEndTime = _votingEndTime;
    }

    /**
     * @notice Add a new candidate to the election
     * @param _name The candidate's name
     * @param _imageUrl The candidate's image URL
     */
    function addCandidate(string calldata _name, string calldata _imageUrl) external onlyAdmin {
        require(!candidateExists[_name], "Candidate with this name already exists");
        
        candidates.push(Candidate({
            id: candidates.length, 
            name: _name, 
            imageUrl: _imageUrl, 
            voteCount: 0
        }));

        candidateExists[_name] = true;
        emit CandidateAdded(_name, candidates.length - 1);
    }

    /**
     * @notice Register a new voter
     * @param _voter Address of the voter to register
     */
    function registerVoter(address _voter) external onlyAdmin {
        require(!registeredVoters[_voter], "Voter is already registered");
        registeredVoters[_voter] = true;
        emit VoterRegistered(_voter);
    }

    /**
     * @notice Vote for a candidate
     * @param _candidateId The candidate's ID
     */
    function vote(uint _candidateId) external votingActive onlyRegisteredVoter {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");
        
        sender.voted = true;
        sender.vote = _candidateId;
        
        candidates[_candidateId].voteCount += 1;
        
        emit Voted(msg.sender, _candidateId);
    }

    /**
     * @notice End the voting session
     */
    function endVoting() external onlyAdmin {
        require(votingOpen, "Voting already ended");
        votingOpen = false;
        emit VotingEnded();
    }

    /**
     * @notice Get candidate info by ID
     * @param _candidateId The candidate's ID
     * @return name The name of the candidate
     * @return voteCount The number of votes for the candidate
     */
    function getCandidate(uint _candidateId) external view returns (string memory name, uint voteCount) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        Candidate storage candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }

    /**
     * @notice Get all candidates' details
     * @return All candidates
     */
    function getAllCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    /**
     * @notice Get total number of candidates
     * @return Total number of candidates
     */
    function totalCandidates() external view returns (uint) {
        return candidates.length;
    }
}
