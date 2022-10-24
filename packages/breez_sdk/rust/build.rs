fn main() -> Result<(), Box<dyn std::error::Error>> {
    let builder = tonic_build::configure();

    // Relative path to breez.proto from server repo, checked-out next to c-breez repo
    let proto_files = &["./../../../../server/breez/breez.proto"];
    let dirs =        &["./../../../../server/breez"];

    builder
        .build_client(true)
        .build_server(false)
        .out_dir(&"src/grpc/")// Path where generated breez.rs will be placed
        .compile(proto_files, dirs)
        .unwrap_or_else(|e| panic!("protobuf compilation failed: {}", e));

    // Recompile protobufs only if protobuf files changed
    for proto_file in proto_files {
        println!("cargo:rerun-if-changed={}", proto_file);
    }

    Ok(())
}

