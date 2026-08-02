import argparse
import yaml

def make_yaml(model_name, img_size, channels, wbits, abits, target_fps, batch_size):
    output_dir = f"./finn_out/{img_size}x{img_size}_w{wbits}a{abits}_c{'x'.join(str(c) for c in channels)}/outputs/output_{target_fps}"

    data = {
        "board": "Pynq-Z2",
        "shell_flow_type": "vivado_zynq",
        "synth_clk_period_ns": 10.0,
        "target_fps": target_fps,
        "rtlsim_batch_size": batch_size,
        "model_path": f"./models/{model_name}.onnx",
        "output_dir": output_dir,
        "save_intermediate_models": True,

        "steps": [
            "step_qonnx_to_finn",
            "transform_input.step_transform_input",
            "step_tidy_up",
            "step_streamline",
            "step_convert_to_hw",
            "step_create_dataflow_partition",
            "step_specialize_layers",
            "step_target_fps_parallelization",
            "step_apply_folding_config",
            "step_generate_estimate_reports",
            "step_hw_codegen",
            "step_hw_ipgen",
            "step_insert_dwc",
            "step_set_fifo_depths",
            "step_create_stitched_ip",
            "step_measure_rtlsim_performance",
            "step_out_of_context_synthesis",
            "step_synthesize_bitfile",
            "step_make_driver"
        ],

        "generate_outputs": [
            "estimate_reports",
            "stitched_ip",
            "rtlsim_performance",
            "bitfile",
            "pynq_driver"
        ]
    }

    yaml_filename = f"build_{model_name}_fps{target_fps}.yaml"
    with open(yaml_filename, "w") as f:
        yaml.dump(data, f)

    print(f"Generated YAML: {yaml_filename}")
    print(f"Output dir: {output_dir}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate FINN build YAML")

    parser.add_argument("--img_size", type=int, required=True)
    parser.add_argument("--channels", type=str, required=True)
    parser.add_argument("--wbits", type=int, required=True)
    parser.add_argument("--abits", type=int, required=True)
    parser.add_argument("--target_fps", type=int, required=True)
    parser.add_argument("--batch_size", type=int, default=1000)

    args = parser.parse_args()

    channels = [int(c) for c in args.channels.split(",")]

    model_name = f"gtsrb_{args.img_size}x{args.img_size}_w{args.wbits}a{args.abits}_c{'x'.join(str(c) for c in channels)}"

    make_yaml(
        model_name=model_name,
        img_size=args.img_size,
        channels=channels,
        wbits=args.wbits,
        abits=args.abits,
        target_fps=args.target_fps,
        batch_size=args.batch_size
    )