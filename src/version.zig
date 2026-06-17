/// Build-time version metadata exported by the agent.
pub const current = @import("build_options").version;
pub const repo = @import("build_options").release_repo;
