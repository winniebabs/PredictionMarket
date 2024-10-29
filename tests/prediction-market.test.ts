import { describe, it, expect } from "vitest";
import { createMarket, placeBet, resolveMarket, withdraw } from "./prediction-market";

describe("Prediction Market Platform", () => {
  describe("createMarket", () => {
    it("should create a new market with the correct details", () => {
      const marketId = createMarket("Election 2024", 3);
      expect(marketId).toBe(1);
      
      const market = getMarket(marketId);
      expect(market.eventName).toBe("Election 2024");
      expect(market.outcomeCount).toBe(3);
      expect(market.totalBets).toBe(0);
      expect(market.status).toBe(false);
    });
  });
  
  describe("placeBet", () => {
    it("should allow users to place bets on a market", () => {
      const marketId = createMarket("Election 2024", 3);
      placeBet(marketId, 0, 100);
      
      const market = getMarket(marketId);
      expect(market.totalBets).toBe(100);
      expect(market.outcomes[0].totalBets).toBe(100);
    });
    
    it("should not allow bets on invalid outcomes", () => {
      const marketId = createMarket("Election 2024", 3);
      expect(() => placeBet(marketId, 3, 100)).toThrow();
    });
  });
  
  describe("resolveMarket", () => {
    it("should correctly calculate payouts for a resolved market", () => {
      const marketId = createMarket("Election 2024", 3);
      placeBet(marketId, 0, 100);
      placeBet(marketId, 1, 200);
      placeBet(marketId, 2, 300);
      
      resolveMarket(marketId, 2);
      
      const market = getMarket(marketId);
      expect(market.status).toBe(true);
      
      const bet1 = getBet(marketId, 0);
      expect(bet1.payoutAmount).toBe(333);
      
      const bet2 = getBet(marketId, 1);
      expect(bet2.payoutAmount).toBe(667);
      
      const bet3 = getBet(marketId, 2);
      expect(bet3.payoutAmount).toBe(1000);
    });
  });
  
  describe("withdraw", () => {
    it("should allow users to withdraw their winnings", () => {
      const marketId = createMarket("Election 2024", 3);
      placeBet(marketId, 0, 100);
      resolveMarket(marketId, 0);
      
      withdraw(marketId, 0);
      const bet = getBet(marketId, 0);
      expect(bet).toBeUndefined();
    });
    
    it("should not allow withdrawal for unresolved markets", () => {
      const marketId = createMarket("Election 2024", 3);
      placeBet(marketId, 0, 100);
      expect(() => withdraw(marketId, 0)).toThrow();
    });
  });
});

function getMarket(marketId) {
  // Implement function to retrieve market data
}

function getBet(marketId, outcome) {
  // Implement function to retrieve bet data
}

