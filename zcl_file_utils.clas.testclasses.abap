*"* use this source file for your ABAP unit test classes
class ltcl_file_utils definition final for testing
  duration short
  risk level harmless.

  public section.
    interfaces zif_file_utils.

  private section.
    data cut type ref to zcl_file_utils.

    methods:
      setup,
      mkdir_created_folder for testing raising cx_static_check.
endclass.


class ltcl_file_utils implementation.

  method mkdir_created_folder.
    cut->mkdir( '/tmp/temp_folder/folder2' ).

    cl_abap_unit_assert=>assert_true(
      act = cut->exists(
        fullpath = '/tmp/temp_folder'
        object   = 'folder2' )
      msg = 'File not found'
     ).
  endmethod.

  method setup.
    cut = new #(  ).
  endmethod.

endclass.
