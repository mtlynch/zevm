pub const ZERO: u64 = 0;
pub const ONE: u64 = 1;
pub const TWO: u64 = 2;
pub const VERYLOW: u64 = 3;
pub const LOW: u64 = 5;
pub const HIGH: u64 = 100;
pub const HIGHEST: u64 = 32000;

pub const Tracker = struct {
    limit: u64,
    total_used: u64,
    no_mem_used: u64,
    mem_used: u64,
    refunded: i64,
    pub fn init(gas_limit: u64) Tracker {
        return .{
            .limit = gas_limit,
            .total_used = 0,
            .no_mem_used = 0,
            .mem_used = 0,
            .refunded = 0,
        };
    }
    pub inline fn recordGasCost(self: *Tracker, cost: u64) bool {
        // Check if we overflow.
        const max_u64 = (1 << 64) - 1;
        if (self.total_used >= max_u64 - cost) {
            return false;
        }
        const all_used = self.total_used + cost;
        if (all_used >= self.limit) {
            return false;
        }
        self.no_mem_used += cost;
        self.total_used = all_used;
        return true;
    }
};
