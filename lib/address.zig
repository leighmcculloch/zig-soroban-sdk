// Soroban Address and Auth utilities.
//
// Thin wrappers around the address host functions for authentication
// and address manipulation.

const val = @import("val.zig");
const env = @import("env.zig");

pub const Address = struct {
    obj: val.AddressObject,

    /// Wrap a raw AddressObject.
    pub fn fromObject(obj: val.AddressObject) Address {
        return .{ .obj = obj };
    }

    /// Get the underlying AddressObject.
    pub fn toObject(self: Address) val.AddressObject {
        return self.obj;
    }

    /// Require that this address has authorized the invocation of the
    /// current contract function with all its arguments.
    pub fn requireAuth(self: Address) void {
        _ = env.address.require_auth(self.obj);
    }

    /// Require that this address has authorized the invocation of the
    /// current contract function with the provided arguments.
    pub fn requireAuthForArgs(self: Address, args: val.VecObject) void {
        _ = env.address.require_auth_for_args(self.obj, args);
    }

    /// Convert this address to a Stellar strkey string ('G...' or 'C...').
    pub fn toStrkey(self: Address) val.StringObject {
        return env.address.address_to_strkey(self.obj);
    }

    /// Get the executable information for this address.
    pub fn getExecutable(self: Address) val.Val {
        return env.address.get_address_executable(self.obj);
    }
};

/// Convert a Stellar strkey ('G...' or 'C...') to an Address.
/// The strkey can be either a BytesObject or StringObject.
pub fn strkeyToAddress(strkey: val.Val) Address {
    return Address.fromObject(env.address.strkey_to_address(strkey));
}

/// Authorize sub-contract calls on behalf of the current contract.
pub fn authorizeAsCurrContract(auth_entries: val.VecObject) void {
    _ = env.address.authorize_as_curr_contract(auth_entries);
}

/// Get the Address from a MuxedAddressObject (strips the multiplexing id).
pub fn getAddressFromMuxedAddress(muxed: val.MuxedAddressObject) Address {
    return Address.fromObject(env.address.get_address_from_muxed_address(muxed));
}

/// Get the multiplexing id from a MuxedAddressObject.
pub fn getIdFromMuxedAddress(muxed: val.MuxedAddressObject) val.U64Val {
    return env.address.get_id_from_muxed_address(muxed);
}
