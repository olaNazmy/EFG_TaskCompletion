namespace StockProfitWithFee
{
    class StockProfitWithFee
    {
        // Static function that will Calculate the Max profit considering the Fee
        public static int MaxProfit(int[] prices, int fee)
        {
            int n  = prices.Length;
            if (n == 0) return 0;

            // Max profit without holding any stock
            int cash = 0;
            // Max profit holding a stock (if i bought the first day, not having any profit at the day)
            int hold = -prices[0];  

            for(int i = 1;i<prices.Length;i++)
            {
                // i will update 2 cases , first if sell , then if i buy , without having stock
                cash = Math.Max(cash, hold + prices[i] - fee);
                //msx profit with having stock
                hold = Math.Max(hold, cash - prices[i]);

            }

            return cash;
        }
    }

    internal class ProgramForMaxProfit
    {
        static void Main(string[] args)
        {
            int[] prices = { 1, 3, 2, 8, 4, 9 };
            int maxProfit = StockProfitWithFee.MaxProfit(prices,2);
            Console.WriteLine($"Max profit is {maxProfit}");
            // 
            int[] prices2 = { 1, 3, 7, 5, 10, 3 };
            int maxProfit2 = StockProfitWithFee.MaxProfit(prices2, 3);
            Console.WriteLine($"Max profit is {maxProfit2}");

        }
    }
}
