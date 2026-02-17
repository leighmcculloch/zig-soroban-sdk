// Soroban Address and Auth utilities.
//
// Address is a host-managed address accessed via a 64-bit tagged handle.

const val = @import("val.zig");
const env = @import("env.zig");
const Vec = @import("vec.zig").Vec;

pub const Address = extern struct {
    payload: u64,

    pub fn toVal(self: Address) val.Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: val.Val) Address {
        return .{ .payload = v.payload };
    }

    pub fn getHandle(self: Address) u32 {
        return @truncate(self.payload >> 32);
    }

    /// Require that this address has authorized the invocation of the
    /// current contract function with all its arguments.
    pub fn requireAuth(self: Address) void {
        _ = env.address.require_auth(self);
    }

    /// Require that this address has authorized the invocation of the
    /// current contract function with the provided arguments.
    pub fn requireAuthForArgs(self: Address, args: Vec) void {
        _ = env.address.require_auth_for_args(self, args);
    }

    /// Convert this address to a Stellar strkey string ('G...' or 'C...').
    pub fn toStrkey(self: Address) val.StringObject {
        return env.address.address_to_strkey(self);
    }

    /// Get the executable information for this address.
    pub fn getExecutable(self: Address) val.Val {
        return env.address.get_address_executable(self);
    }
};

/// Convert a Stellar strkey ('G...' or 'C...') to an Address.
/// The strkey can be either a Bytes or StringObject.
pub fn strkeyToAddress(strkey: val.Val) Address {
    return env.address.strkey_to_address(strkey);
}

/// Authorize sub-contract calls on behalf of the current contract.
pub fn authorizeAsCurrContract(auth_entries: Vec) void {
    _ = env.address.authorize_as_curr_contract(auth_entries);
}

/// Get the Address from a MuxedAddressObject (strips the multiplexing id).
pub fn getAddressFromMuxedAddress(muxed: val.MuxedAddressObject) Address {
    return env.address.get_address_from_muxed_address(muxed);
}

/// Get the multiplexing id from a MuxedAddressObject.
pub fn getIdFromMuxedAddress(muxed: val.MuxedAddressObject) val.U64Val {
    return env.address.get_id_from_muxed_address(muxed);
}
