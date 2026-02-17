// Soroban cryptography utilities.
//
// Thin wrappers around the crypto host functions for hashing,
// signature verification, and elliptic curve operations.

const val = @import("val.zig");
const env = @import("env.zig");

// -----------------------------------------------------------------------
// Hashing
// -----------------------------------------------------------------------

/// Compute the SHA-256 hash of the given bytes.
pub fn sha256(data: val.Bytes) val.Bytes {
    return env.crypto.compute_hash_sha256(data);
}

/// Compute the Keccak-256 hash of the given bytes.
pub fn keccak256(data: val.Bytes) val.Bytes {
    return env.crypto.compute_hash_keccak256(data);
}

// -----------------------------------------------------------------------
// Signature verification
// -----------------------------------------------------------------------

/// Verify an Ed25519 signature. Traps if verification fails.
/// `public_key` is a 32-byte Ed25519 public key.
/// `message` is the signed message.
/// `signature` is a 64-byte Ed25519 signature.
pub fn verifyEd25519(public_key: val.Bytes, message: val.Bytes, signature: val.Bytes) void {
    _ = env.crypto.verify_sig_ed25519(public_key, message, signature);
}

/// Verify an ECDSA secp256r1 signature. Traps if verification fails.
/// `public_key` is a 65-byte SEC-1 uncompressed public key.
/// `msg_digest` is a 32-byte hash digest.
/// `signature` is the ECDSA signature (r, s) as fixed-size big-endian scalars.
pub fn verifyEcdsaSecp256r1(public_key: val.Bytes, msg_digest: val.Bytes, signature: val.Bytes) void {
    _ = env.crypto.verify_sig_ecdsa_secp256r1(public_key, msg_digest, signature);
}

/// Recover the ECDSA secp256k1 public key from a signature.
/// `msg_digest` is a 32-byte hash digest.
/// `signature` is a 64-byte ECDSA signature (r, s).
/// `recovery_id` is 0, 1, 2, or 3.
/// Returns a 65-byte SEC-1 uncompressed public key.
pub fn recoverEcdsaSecp256k1(msg_digest: val.Bytes, signature: val.Bytes, recovery_id: u32) val.Bytes {
    return env.crypto.recover_key_ecdsa_secp256k1(msg_digest, signature, val.U32Val.fromU32(recovery_id));
}

// -----------------------------------------------------------------------
// BLS12-381 operations
// -----------------------------------------------------------------------

pub const bls12_381 = struct {
    pub fn checkG1IsInSubgroup(point: val.Bytes) bool {
        return env.crypto.bls12_381_check_g1_is_in_subgroup(point).toBool();
    }

    pub fn g1Add(p1: val.Bytes, p2: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_g1_add(p1, p2);
    }

    pub fn g1Mul(point: val.Bytes, scalar: val.U256Val) val.Bytes {
        return env.crypto.bls12_381_g1_mul(point, scalar);
    }

    pub fn g1Msm(points: val.Vec, scalars: val.Vec) val.Bytes {
        return env.crypto.bls12_381_g1_msm(points, scalars);
    }

    pub fn mapFpToG1(fp: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_map_fp_to_g1(fp);
    }

    pub fn hashToG1(msg: val.Bytes, dst: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_hash_to_g1(msg, dst);
    }

    pub fn checkG2IsInSubgroup(point: val.Bytes) bool {
        return env.crypto.bls12_381_check_g2_is_in_subgroup(point).toBool();
    }

    pub fn g2Add(p1: val.Bytes, p2: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_g2_add(p1, p2);
    }

    pub fn g2Mul(point: val.Bytes, scalar: val.U256Val) val.Bytes {
        return env.crypto.bls12_381_g2_mul(point, scalar);
    }

    pub fn g2Msm(points: val.Vec, scalars: val.Vec) val.Bytes {
        return env.crypto.bls12_381_g2_msm(points, scalars);
    }

    pub fn mapFp2ToG2(fp2: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_map_fp2_to_g2(fp2);
    }

    pub fn hashToG2(msg: val.Bytes, dst: val.Bytes) val.Bytes {
        return env.crypto.bls12_381_hash_to_g2(msg, dst);
    }

    pub fn multiPairingCheck(g1_points: val.Vec, g2_points: val.Vec) bool {
        return env.crypto.bls12_381_multi_pairing_check(g1_points, g2_points).toBool();
    }

    pub fn frAdd(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bls12_381_fr_add(lhs, rhs);
    }

    pub fn frSub(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bls12_381_fr_sub(lhs, rhs);
    }

    pub fn frMul(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bls12_381_fr_mul(lhs, rhs);
    }

    pub fn frPow(base: val.U256Val, exp: val.U64Val) val.U256Val {
        return env.crypto.bls12_381_fr_pow(base, exp);
    }

    pub fn frInv(v: val.U256Val) val.U256Val {
        return env.crypto.bls12_381_fr_inv(v);
    }

    pub fn g1IsOnCurve(point: val.Bytes) bool {
        return env.crypto.bls12_381_g1_is_on_curve(point).toBool();
    }

    pub fn g2IsOnCurve(point: val.Bytes) bool {
        return env.crypto.bls12_381_g2_is_on_curve(point).toBool();
    }
};

// -----------------------------------------------------------------------
// BN254 operations
// -----------------------------------------------------------------------

pub const bn254 = struct {
    pub fn g1Add(p1: val.Bytes, p2: val.Bytes) val.Bytes {
        return env.crypto.bn254_g1_add(p1, p2);
    }

    pub fn g1Mul(point: val.Bytes, scalar: val.U256Val) val.Bytes {
        return env.crypto.bn254_g1_mul(point, scalar);
    }

    pub fn g1Msm(points: val.Vec, scalars: val.Vec) val.Bytes {
        return env.crypto.bn254_g1_msm(points, scalars);
    }

    pub fn multiPairingCheck(g1_points: val.Vec, g2_points: val.Vec) bool {
        return env.crypto.bn254_multi_pairing_check(g1_points, g2_points).toBool();
    }

    pub fn frAdd(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bn254_fr_add(lhs, rhs);
    }

    pub fn frSub(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bn254_fr_sub(lhs, rhs);
    }

    pub fn frMul(lhs: val.U256Val, rhs: val.U256Val) val.U256Val {
        return env.crypto.bn254_fr_mul(lhs, rhs);
    }

    pub fn frPow(base: val.U256Val, exp: val.U64Val) val.U256Val {
        return env.crypto.bn254_fr_pow(base, exp);
    }

    pub fn frInv(v: val.U256Val) val.U256Val {
        return env.crypto.bn254_fr_inv(v);
    }

    pub fn g1IsOnCurve(point: val.Bytes) bool {
        return env.crypto.bn254_g1_is_on_curve(point).toBool();
    }
};

// -----------------------------------------------------------------------
// Poseidon hash functions
// -----------------------------------------------------------------------

/// Perform Poseidon permutation on the input vector.
/// `input` is a vector of field elements (length t).
/// `field` is 'BLS12_381' or 'BN254' as a Symbol.
/// `t` is the state size.
/// `d` is the S-box degree (5 for BLS12_381/BN254).
/// `rounds_f` is the number of full rounds (must be even).
/// `rounds_p` is the number of partial rounds.
/// `mds` is the t-by-t MDS matrix as Vec<Vec<Scalar>>.
/// `round_constants` is the (rounds_f+rounds_p)-by-t round constants matrix.
pub fn poseidonPermutation(
    input: val.Vec,
    field: val.Symbol,
    t: val.U32Val,
    d: val.U32Val,
    rounds_f: val.U32Val,
    rounds_p: val.U32Val,
    mds: val.Vec,
    round_constants: val.Vec,
) val.Vec {
    return env.crypto.poseidon_permutation(input, field, t, d, rounds_f, rounds_p, mds, round_constants);
}

/// Perform Poseidon2 permutation on the input vector.
/// `input` is a vector of field elements (length t).
/// `field` is 'BLS12_381' or 'BN254' as a Symbol.
/// `t` is the state size.
/// `d` is the S-box degree (5 for BLS12_381/BN254).
/// `rounds_f` is the number of full rounds (must be even).
/// `rounds_p` is the number of partial rounds.
/// `mat_internal_diag_m_1` is the internal matrix diagonal minus 1 as Vec<Scalar> (length t).
/// `round_constants` is the (rounds_f+rounds_p)-by-t round constants matrix.
pub fn poseidon2Permutation(
    input: val.Vec,
    field: val.Symbol,
    t: val.U32Val,
    d: val.U32Val,
    rounds_f: val.U32Val,
    rounds_p: val.U32Val,
    mat_internal_diag_m_1: val.Vec,
    round_constants: val.Vec,
) val.Vec {
    return env.crypto.poseidon2_permutation(input, field, t, d, rounds_f, rounds_p, mat_internal_diag_m_1, round_constants);
}
