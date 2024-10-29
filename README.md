# Prediction Market Platform

A decentralized platform where users can bet on the outcomes of future events, such as elections or sports.

## Features

- **Market Creation**: Users can create new prediction markets by providing the event name and the number of possible outcomes.
- **Placing Bets**: Users can place bets on the outcome of a market, specifying the market ID and the outcome they are betting on.
- **Market Resolution**: Market creators can resolve a market by providing the winning outcome. This triggers the payout calculation and updates the market status.
- **Withdrawing Winnings**: Users can withdraw their winnings from a resolved market by specifying the market ID and the outcome they bet on.

## Tech Stack

- **Language**: Clarity (Clarity is a smart contract language for the Stacks blockchain)
- **Testing Framework**: Vitest

## Getting Started

1. **Install Dependencies**:
   ```
   npm install
   ```

2. **Run Tests**:
   ```
   npx vitest
   ```

3. **Deploy Contracts**:
    - TBD (Deployment instructions will depend on the specific blockchain platform)

## Usage

1. **Create a New Market**:
   ```clarity
   (create-market "Election 2024" 3)
   ```

2. **Place a Bet**:
   ```clarity
   (place-bet 1 0 100)
   ```

3. **Resolve a Market**:
   ```clarity
   (resolve-market 1 2)
   ```

4. **Withdraw Winnings**:
   ```clarity
   (withdraw 1 0)
   ```

## Contributing

We welcome contributions to the Prediction Market Platform! If you have any ideas, bug fixes, or feature enhancements, please submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
