import { defineCommand, runMain } from "citty";

runMain(defineCommand({
    meta: {
        name: "generate-env",
        description: "Generate env.zig from env.json",
    },
    args: {
        protocol: {
            type: "string",
            description: "Protocol version",
            required: true,
        },
    },
    async run({ args }) {
        const url =
            `https://raw.githubusercontent.com/stellar/rs-soroban-env/v${args.protocol}.0.0/soroban-env-common/env.json`;
        const resp = await (await fetch(url, { redirect: "follow" })).json();

        let out = "";
        out += `
// Generated from ${url}.
pub const Val = u64;
pub const Void = Val;
pub const Error = Val;
pub const U32Val = Val;
pub const I32Val = Val;
pub const U64Val = Val;
pub const I64Val = Val;
pub const BytesObject = Val;
pub const AddressObject = Val;
pub const U64Object = Val;
pub const I64Object = Val;
pub const U128Object = Val;
pub const I128Object = Val;
pub const U128Val = Val;
pub const I128Val = Val;
pub const U256Object = Val;
pub const I256Object = Val;
pub const U256Val = Val;
pub const I256Val = Val;
pub const TimepointObject = Val;
pub const DurationObject = Val;
pub const MapObject = Val;
pub const Bool = Val;
pub const VecObject = Val;
pub const StringObject = Val;
pub const SymbolObject = Val;
pub const Symbol = Val;
pub const StorageType = Val;
`;
        for (const m of resp.modules) {
            out += `pub const @"${m.name}" = struct {`;
            for (const f of m.functions) {
                out += `pub const @"${f.name}" = @extern(`;
                out += `*const fn(`;
                for (const a of f.args) {
                    out += `@"${a.name}": ${a.type},`;
                }
                out += `) callconv(.C) ${f.return},`;
                out +=
                    `.{ .library_name = "${m.export}", .name = "${f.export}"});`;
            }
            out += `};`;
        }

        console.log(out);
    },
}));
