class zcl_file_utils definition
  public
  final
  create public .

  public section.
    interfaces zif_file_utils.


    "! Get directory listing for directory with param fullpath<br/>
    "! Using ZLS commandname 'ls' for AIX with params '-lA' (SM69)<br/>
    "! <br/>
    "! <strong>How to use:</strong><br/>
    "! data(file_utils) = new zcl_file_utils( ).<br/>
    "! data(folders_itab) = file_utils-&gt;ls( 'your/path' ).<br/>
    "!
    "! @parameter fullpath | path for ls command, string
    "! @parameter list     | itab with listing content with type zif_file_utilsty_ls_command_result~ty_ls_command_result
    methods ls
      importing
                fullpath    type string
      returning value(list) type zif_file_utils~tt_dir_content.

    "! Create directory. Using ZMKDIR commandname 'mkdir' for AIX with params '-m 777 -p' (SM69)
    "!
    "! @parameter fullpath | path for ls command, string
    methods mkdir
      importing fullpath type string.

    "! Check exists objects (folders, files, etc.) for AIX OS (case sensitive!)
    "!
    "! @parameter fullpath | path for ls command, string
    "! @parameter object   | file or folder name for check
    methods exists
      importing
                fullpath    type string
                object      type string
      returning value(succ) type abap_bool.

  protected section.
  private section.
    types ty_protocol type standard table of btcxpm with empty key.
    methods exec
      importing
                commandname  type string
                param        type string
      returning value(r_tab) type ty_protocol.
ENDCLASS.



CLASS ZCL_FILE_UTILS IMPLEMENTATION.


  method exec.
    data lv_status type extcmdexex-status.
    data lv_exitcode type extcmdexex-exitcode.

    data(cmd) = conv sxpgcolist-name( commandname ).
    data(add_prm) = conv sxpgcolist-parameters( param ).

    call function 'SXPG_CALL_SYSTEM'
      exporting
        commandname                = cmd
        additional_parameters      = add_prm
      importing
        status                     = lv_status
        exitcode                   = lv_exitcode
      tables
        exec_protocol              = r_tab
      exceptions
        no_permission              = 1
        command_not_found          = 2
        parameters_too_long        = 3
        security_risk              = 4
        wrong_check_call_interface = 5
        program_start_error        = 6
        program_termination_error  = 7
        x_error                    = 8
        parameter_expected         = 9
        too_many_parameters        = 10
        illegal_command            = 11
        others                     = 12.
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.
  endmethod.


  method exists.
    data(folders) = ls( fullpath ).
    succ = abap_false.
    loop at folders reference into data(rec).
      if rec->file_name = object.
        succ = abap_true.
      endif.
    endloop.
  endmethod.


  method ls.
    data result type zif_file_utils~ty_ls_command_result.

    data(lt_protocol) = exec(
       commandname = 'ZLS'
       param = fullpath
    ).


    loop at lt_protocol reference into data(row).
      result = row->message.
      if result-rights+0(5) ne 'total'.
        append value zif_file_utils~ty_dir_content(
          file_name = condense( result-file_name )
          file_type = conv i( result-file_type )
          block_length = conv i( result-block_length )
          rights = result-rights
          owner = condense( result-owner )
          group = condense( result-group )
          created = condense( result-created )
        ) to list.
      endif.
    endloop.
  endmethod.


  method mkdir.
    exec( commandname = 'ZMKDIR' param = fullpath ).
  endmethod.
ENDCLASS.
