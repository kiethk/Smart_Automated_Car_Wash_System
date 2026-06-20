package dto;

public class Wallet {
    private int walletId;
    private long balance; // BIGINT -> long (Số dư ví VND)
    private int customerId; // UNIQUE

    public Wallet() {}

    public Wallet(int walletId, long balance, int customerId) {
        this.walletId = walletId;
        this.balance = balance;
        this.customerId = customerId;
    }

    // Getters and Setters
    public int getWalletId() { return walletId; }
    public void setWalletId(int walletId) { this.walletId = walletId; }
    public long getBalance() { return balance; }
    public void setBalance(long balance) { this.balance = balance; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}