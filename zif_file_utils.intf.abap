interface zif_file_utils
  public .
  types: begin of ty_ls_command_result,
           rights       type c length 10,
           blank_1      type c length 4,
           file_type    type c length 1,
           blank_2      type c length 1,
           owner        type c length 9,
           group        type c length 9,
           block_length type c length 10,
           blank_3      type c length 1,
           created      type c length 13,
           file_name    type c length 196,
         end of ty_ls_command_result.

  types tt_ls_command_result type standard table of ty_ls_command_result with empty key.

  types: begin of ty_dir_content,
           file_name    type c length 254,
           rights       type c length 10,
           file_type    type i,
           block_length type i,
           owner        type c length 6,
           group        type c length 6,
           created      type c length 14,
         end of ty_dir_content.

  types tt_dir_content type standard table of ty_dir_content with empty key.

endinterface.
