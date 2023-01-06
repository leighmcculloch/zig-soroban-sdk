use std::{error::Error, fs, path::PathBuf};

use clap::Parser;
use stellar_xdr::next::{
    ScEnvMetaEntry, ScSpecEntry, ScSpecFunctionInputV0, ScSpecFunctionV0, ScSpecTypeDef, WriteXdr,
};

#[derive(Parser, Debug, Clone)]
#[command(author, version, about)]
struct Cmd {
    /// Wasm file to write custom sections to
    #[arg(long)]
    wasm: PathBuf,
}

fn main() -> Result<(), Box<dyn Error>> {
    let cmd = Cmd::parse();

    let mut wasm = fs::read(&cmd.wasm)?;
    write_env_meta(&mut wasm)?;
    write_spec(&mut wasm)?;
    fs::write(&cmd.wasm, wasm)?;

    Ok(())
}

fn write_env_meta(wasm: &mut Vec<u8>) -> Result<(), Box<dyn Error>> {
    let env_meta_entries = [ScEnvMetaEntry::ScEnvMetaKindInterfaceVersion(27)];
    let mut env_meta_stream = vec![];
    for entry in env_meta_entries {
        entry.write_xdr(&mut env_meta_stream)?;
    }
    wasm_gen::write_custom_section(wasm, "contractenvmetav0", &env_meta_stream);
    Ok(())
}

fn write_spec(wasm: &mut Vec<u8>) -> Result<(), Box<dyn Error>> {
    let spec_entries = [ScSpecEntry::FunctionV0(ScSpecFunctionV0 {
        name: "add".try_into().unwrap(),
        inputs: [
            ScSpecFunctionInputV0 {
                name: "a".try_into().unwrap(),
                type_: ScSpecTypeDef::Bool,
            },
            ScSpecFunctionInputV0 {
                name: "b".try_into().unwrap(),
                type_: ScSpecTypeDef::I64,
            },
            ScSpecFunctionInputV0 {
                name: "c".try_into().unwrap(),
                type_: ScSpecTypeDef::I64,
            },
        ]
        .try_into()
        .unwrap(),
        outputs: [ScSpecTypeDef::I64].try_into().unwrap(),
    })];
    let mut spec_stream = vec![];
    for entry in spec_entries {
        entry.write_xdr(&mut spec_stream)?;
    }
    wasm_gen::write_custom_section(wasm, "contractspecv0", &spec_stream);
    Ok(())
}
