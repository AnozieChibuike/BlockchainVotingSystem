# Voting System Smart Contract

A simple, gas-efficient voting system written in Solidity that allows for secure, decentralized elections on the Ethereum blockchain. This contract includes features like registered voters, a time-based voting window, and candidate registration. It ensures that only registered voters can vote, each voter can vote once, and the voting process occurs within a specified time frame.

## Features

- <b>Candidate Registration</b>: Admin can add candidates with their name and image URL.

- <b>Voter Registration</b>: Admin can register specific Ethereum addresses as eligible voters.

- <b>Vote Casting</b>: Registered voters can cast their vote for any candidate during the active voting period.

- <b>Voting Timeframe</b>: Voting is allowed only between a start and end time specified by the admin.

- <b>Vote Tracking</b>: Each voter can only vote once, and the vote is permanently recorded on the blockchain.

- <b>Results Viewing</b>: Anyone can view the candidates and their current vote counts.

## Smart Contract Breakdown

### Contract Variables

- `admin`: The address of the contract creator who has exclusive control over admin functions like adding candidates and registering voters.

- `votingOpen`: A boolean flag to check whether voting is still active.

- `votingStartTime`: The timestamp when voting begins.

- `votingEndTime`: The timestamp when voting ends.

### Structs

1. <b>Candidate</b>: Holds details about each candidate:

   - `id`: Unique ID of the candidate.
   - `name`: Name of the candidate.
   - `imageUrl`: URL to the candidate's image.
   - `voteCount`: Number of votes the candidate has received.

2. <b>Voter</b>: Keeps track of voter details:

   - `voted`: Whether the voter has cast a vote or not.
   - `vote`: ID of the candidate the voter voted for.

### Mappings

- `voters`: Stores voter information mapped by their Ethereum address.

- `registeredVoters`: Keeps track of whether a voter is registered to vote.

- `candidateExists`: Tracks whether a candidate with a given name already exists (to prevent duplicate entries).

### Functions

1. `addCandidate(string calldata _name, string calldata _imageUrl)`:
   Allows the admin to add a new candidate. Emits a `CandidateAdded` event.

2. `registerVoter(address _voter)`:
   Admin function to register a voter by their Ethereum address. Emits a `VoterRegistered` event.

3. `vote(uint _candidateId)`:
   Allows a registered voter to cast their vote for a candidate, provided voting is active and they have not already voted. Emits a `Voted` event.

4. `endVoting()`:
   Allows the admin to end the voting session before the voting period expires. Emits a `VotingEnded` event.

5. `getCandidate(uint \_candidateId)`:
   Returns a candidate's name and vote count by their ID.

6. `getAllCandidates()`:
   Returns all registered candidates.

7. `totalCandidates()`:
   Returns the total number of candidates.

## Setup Instructions

### Prerequisites

1. <b>Node.js & NPM</b>: Ensure you have Node.js installed on your machine.

   - [Download Node.js](https://nodejs.org/en/download/package-manager/current)

2. <b>Truffle or Hardhat</b>: You can use either Truffle or Hardhat for deployment and testing.
   - [Truffle Docs](https://archive.trufflesuite.com/docs/)
   - [Hardhat Docs](https://hardhat.org/docs)

### Clone the repository:

```bash
git clone https://github.com/AnozieChibuikke/BlockchainVotingSystem.git
cd BlockchainVotingSystem
```

### Install Dependencies:

If you're using Truffle, run:

```bash
npm install
```

### Compile the Smart Contract:

For Truffle, run:

```bash
truffle compile
```

For Hardhat, run:

```bash
npx hardhat compile
```

### Deploy the Smart Contract:

For Truffle, run:

```bash
truffle migrate --network <network_name>
```

For Hardhat, run:

```bash
npx hardhat run scripts/deploy.js --network <network_name>
```

### Interact with the Contract:

You can use the Truffle console or Hardhat to interact with the deployed contract.

For Truffle:

```bash
truffle console --network <network_name>
```

For Hardhat:

```bash
npx hardhat console --network <network_name>
```

### Testing

To run tests:

For Truffle:

```bash
truffle test
```

For Hardhat:

```bash
npx hardhat test
```

## Example Usage

### 1. Admin adds candidates:

```js
await votingInstance.addCandidate("Alice", "https://image.url/alice.jpg");

await votingInstance.addCandidate("Bob", "https://image.url/bob.jpg");
```

### 2. Admin registers voters:

```js
await votingInstance.registerVoter("0xVoterAddress1");
await votingInstance.registerVoter("0xVoterAddress2");
```

### 3. Voters cast their votes:

```js
await votingInstance.vote(0, { from: "0xVoterAddress1" }); // Votes for Alice
await votingInstance.vote(1, { from: "0xVoterAddress2" }); // Votes for Bob
```

### 4. End voting:

```js
await votingInstance.endVoting({ from: admin });
```

### 5. View candidate results:

```js
let candidate = await votingInstance.getCandidate(0); // Get Alice's data
```

## Events

- `CandidateAdded(string name, uint id)`: Emitted when a new candidate is added.
- `VoterRegistered(address voter)`: Emitted when a voter is registered.
- `Voted(address indexed voter, uint indexed candidateId)`: Emitted when a voter casts a vote.
- `VotingEnded()`: Emitted when the admin ends the voting.

## Security Considerations

- <b>Only Admin Actions</b>: Only the admin can register voters, add candidates, and end the voting.

- <b>Voting Once Per Voter</b>: Each voter can only cast one vote.

- <b>Registered Voters Only</b>: Only registered voters are allowed to vote.

- <b>Time-Restricted Voting</b>: Voting can only happen during the specified voting period.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/AnozieChibuike/BlockchainVotingSystem/blob/master/LICENSE) file for details.
