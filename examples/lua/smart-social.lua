-- Payment Splitter Smart Contract
-- Splits incoming payments equally among 10 wallets

local PaymentSplitter = {}

-- Initialize the contract with 10 wallet addresses
function PaymentSplitter.init()
    -- Store the 10 recipient wallet addresses
    -- Replace these with actual wallet addresses
    PaymentSplitter.wallets = {
        "wallet1_address_here",
        "wallet2_address_here",
        "wallet3_address_here",
        "wallet4_address_here",
        "wallet5_address_here",
        "wallet6_address_here",
        "wallet7_address_here",
        "wallet8_address_here",
        "wallet9_address_here",
        "wallet10_address_here"
    }

    PaymentSplitter.totalWallets = 10
    PaymentSplitter.totalReceived = 0
    PaymentSplitter.totalDistributed = 0
end

-- Receive and split payment
function PaymentSplitter.receiveAndSplit(amount)
    local startTime = os.clock()
    -- Validate amount
    assert(amount > 0, "Amount must be greater than 0")
    assert(type(amount) == "number", "Amount must be a number")

    -- Calculate split amount per wallet
    local amountPerWallet = math.floor(amount / PaymentSplitter.totalWallets)
    local remainder = amount % PaymentSplitter.totalWallets

    -- Track total received
    PaymentSplitter.totalReceived = PaymentSplitter.totalReceived + amount

    -- Distribute to each wallet
    local distributedAmount = 0
    for i, wallet in ipairs(PaymentSplitter.wallets) do
        local transferAmount = amountPerWallet

        -- Add remainder to the first wallet to ensure all funds are distributed
        if i == 1 then
            transferAmount = transferAmount + remainder
        end

        -- Perform the transfer (platform-specific function)
        local success = PaymentSplitter.transfer(wallet, transferAmount)

        if success then
            distributedAmount = distributedAmount + transferAmount
            -- print(string.format("Transferred %d to %s", transferAmount, wallet))
        else
            error(string.format("Failed to transfer to wallet: %s", wallet))
        end
    end
    local endTime = os.clock()
    -- print(string.format("Lua split function executed in %.6f ms", ((endTime - startTime) * 1000)))
    PaymentSplitter.totalDistributed = PaymentSplitter.totalDistributed + distributedAmount

    return {
        success = true,
        totalAmount = amount,
        amountPerWallet = amountPerWallet,
        remainder = remainder,
        distributed = distributedAmount
    }
end

-- Platform-specific transfer function (mock implementation)
-- Replace this with actual blockchain transfer logic
function PaymentSplitter.transfer(toAddress, amount)
    -- This is a placeholder - implement actual transfer logic based on your platform
    -- Example for NEAR: near.transfer(toAddress, amount)
    -- Example for other platforms: use their respective transfer APIs

    -- print(string.format("Mock transfer: %d to %s", amount, toAddress))
    return true
end

-- Update a wallet address (only contract owner should call this)
function PaymentSplitter.updateWallet(index, newAddress)
    assert(index >= 1 and index <= PaymentSplitter.totalWallets, "Invalid wallet index")
    assert(type(newAddress) == "string", "Address must be a string")
    assert(#newAddress > 0, "Address cannot be empty")

    local oldAddress = PaymentSplitter.wallets[index]
    PaymentSplitter.wallets[index] = newAddress

    return {
        success = true,
        message = string.format("Updated wallet %d from %s to %s", index, oldAddress, newAddress)
    }
end

-- Get current wallet configuration
function PaymentSplitter.getWallets()
    return PaymentSplitter.wallets
end

-- Get contract statistics
function PaymentSplitter.getStats()
    return {
        totalWallets = PaymentSplitter.totalWallets,
        totalReceived = PaymentSplitter.totalReceived,
        totalDistributed = PaymentSplitter.totalDistributed,
        wallets = PaymentSplitter.wallets
    }
end

-- Initialize the contract
PaymentSplitter.init()

return PaymentSplitter