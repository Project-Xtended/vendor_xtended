package android
type Product_variables struct {
	Additional_gralloc_10_usage_bits struct {
		Cppflags []string
	}
	Apply_msm8974_1440p_egl_workaround struct {
		Cflags []string
	}
	Bootloader_message_offset struct {
		Cflags []string
	}
	Should_skip_waiting_for_qsee struct {
		Cflags []string
	}
	Device_support_hwfde struct {
		Cflags []string
		Header_libs []string
		Shared_libs []string
	}
	Device_support_hwfde_perf struct {
		Cflags []string
		Overrides []string
		Shared_libs []string
	}
	Device_support_wait_for_qsee struct {
		Cflags []string
	}
	Has_legacy_camera_hal1 struct {
		Cflags []string
		Overrides []string
		Shared_libs []string
	}

	Needs_legacy_camera_hal1_dyn_native_handle struct {
		Cppflags []string
	}

	Uses_media_extensions struct {
		Cflags []string
	}

	Needs_text_relocations struct {
		Cppflags []string
	}
	Target_shim_libs struct {
		Cppflags []string
	}
	Target_needs_netd_direct_connect_rule struct {
		Cppflags []string
	}
	Uses_generic_camera_parameter_library struct {
		Srcs []string
	}
        Uses_qti_camera_device struct {
		Cppflags []string
		Shared_libs []string
        }
	Uses_metadata_as_fde_key struct {
		Cflags []string
	}
	Uses_qcom_bsp_legacy struct {
		Cppflags []string
	}
	Target_init_vendor_lib struct {
		Whole_static_libs []string
	}
	Target_process_sdk_version_override struct {
		Cppflags []string
	}
	Needs_camera_boottime_timestamp struct {
		Cflags []string
		Srcs []string
	}
	Target_camera_needs_client_info struct {
		Cppflags []string
	}
}

type ProductVariables struct {
	Additional_gralloc_10_usage_bits  *string `json:",omitempty"`
	Apply_msm8974_1440p_egl_workaround  *bool `json:",omitempty"`
	Device_support_hwfde  *bool `json:",omitempty"`
	Device_support_hwfde_perf  *bool `json:",omitempty"`
	Device_support_wait_for_qsee  *bool `json:",omitempty"`
	Bootloader_message_offset  *int `json:",omitempty"`
	Has_legacy_camera_hal1  *bool `json:",omitempty"`
	Needs_legacy_camera_hal1_dyn_native_handle  *bool `json:",omitempty"`
	Uses_media_extensions   *bool `json:",omitempty"`
	Java_Source_Overlays *string `json:",omitempty"`
	Needs_text_relocations  *bool `json:",omitempty"`
	Should_skip_waiting_for_qsee  *bool `json:",omitempty"`
	Specific_camera_parameter_library  *string `json:",omitempty"`
	Target_init_vendor_lib  *string `json:",omitempty"`
	Target_shim_libs  *string `json:",omitempty"`
	Target_needs_netd_direct_connect_rule  *bool `json:",omitempty"`
	Uses_generic_camera_parameter_library  *bool `json:",omitempty"`
	Uses_qti_camera_device  *bool `json:",omitempty"`
	Uses_qcom_bsp_legacy  *bool `json:",omitempty"`
	Target_process_sdk_version_override *string `json:",omitempty"`
	Needs_camera_boottime_timestamp  *bool `json:",omitempty"`
	Target_camera_needs_client_info  *bool `json:",omitempty"`
}
