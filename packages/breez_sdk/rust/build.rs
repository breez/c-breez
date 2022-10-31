fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Relative path to protos from server and lspd repos, checked-out next to c-breez repo
    let proto_files = &[
        "./../../../../server/breez/breez.proto",
        "./../../../../lspd/rpc/lspd.proto"
    ];
    let dirs = &[
        "./../../../../server/breez",
        "./../../../../lspd/rpc"
    ];

    // breez.proto
    // Used to initialize a gRPC client for the breez server endpoint
    tonic_build::configure()
        .build_client(true)
        .build_server(false)
        .out_dir(&"src/grpc/")// Path where generated breez.rs will be placed
        .compile(&[proto_files[0]], &[dirs[0]])
        .unwrap_or_else(|e| panic!("breez.proto protobuf compilation failed: {}", e));

    // lspd.proto
    // Not used because of its service or methods definitions, but for some of its proto struct
    tonic_build::configure()
        .build_client(false)
        .build_server(false)
        .out_dir(&"src/grpc/")// Path where generated breez.rs will be placed
        .compile(&[proto_files[1]], &[dirs[1]])
        .unwrap_or_else(|e| panic!("lspd.proto protobuf compilation failed: {}", e));

    // Recompile protobufs only if protobuf files changed
    for proto_file in proto_files {
        println!("cargo:rerun-if-changed={}", proto_file);
    }

    Ok(())
}

