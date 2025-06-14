function(serenity_lib name fs_name)
    cmake_parse_arguments(PARSE_ARGV 2 SERENITY_LIB "EXPLICIT_SYMBOL_EXPORT" "TYPE" "")
    set(EXPLICIT_SYMBOL_EXPORT "")
    if (SERENITY_LIB_EXPLICIT_SYMBOL_EXPORT)
        set(EXPLICIT_SYMBOL_EXPORT "EXPLICIT_SYMBOL_EXPORT")
    endif()
    lagom_lib(${name} ${fs_name} LIBRARY_TYPE ${SERENITY_LIB_TYPE} ${EXPLICIT_SYMBOL_EXPORT} SOURCES ${SOURCES} ${GENERATED_SOURCES})
endfunction()

function(serenity_generated_sources target_name)
    if(DEFINED GENERATED_SOURCES)
        set_source_files_properties(${GENERATED_SOURCES} PROPERTIES GENERATED 1)
        foreach(generated ${GENERATED_SOURCES})
            get_filename_component(generated_name ${generated} NAME)
            add_dependencies(${target_name} generate_${generated_name})
        endforeach()
    endif()
endfunction()

function(lagom_lib target_name fs_name)
    cmake_parse_arguments(LAGOM_LIBRARY "EXPLICIT_SYMBOL_EXPORT" "LIBRARY_TYPE" "SOURCES;LIBS" ${ARGN})
    string(REPLACE "Lib" "" library ${target_name})
    if (NOT LAGOM_LIBRARY_LIBRARY_TYPE)
        set(LAGOM_LIBRARY_LIBRARY_TYPE "")
    endif()
    add_library(${target_name} ${LAGOM_LIBRARY_LIBRARY_TYPE} ${LAGOM_LIBRARY_SOURCES})
    set_target_properties(
        ${target_name} PROPERTIES
        VERSION "${PROJECT_VERSION}"
        SOVERSION "${PROJECT_VERSION_MAJOR}"
        EXPORT_NAME ${library}
        OUTPUT_NAME lagom-${fs_name}
    )
    target_link_libraries(${target_name} PRIVATE ${LAGOM_LIBRARY_LIBS})

    if (NOT "${target_name}" STREQUAL "AK")
        target_link_libraries(${target_name} PRIVATE AK)
    endif()
    serenity_generated_sources(${target_name})
endfunction()


function(generate_clang_module_map target_name)
    cmake_parse_arguments(PARSE_ARGV 1 MODULE_MAP "" "DIRECTORY" "GENERATED_FILES;EXCLUDE_FILES")
    if (NOT MODULE_MAP_DIRECTORY)
        set(MODULE_MAP_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    string(REPLACE "Lib" "" module_name ${target_name})
    set(module_name "${module_name}Cxx")

    set(module_map_file "${CMAKE_CURRENT_BINARY_DIR}/module/module.modulemap")
    set(vfs_overlay_file "${VFS_OVERLAY_DIRECTORY}/${target_name}_vfs_overlay.yaml")

    find_package(Python3 REQUIRED COMPONENTS Interpreter)
    # FIXME: Make this depend on the public headers of the target
    add_custom_command(
        OUTPUT "${module_map_file}"
        COMMAND "${Python3_EXECUTABLE}" "${PROJECT_SOURCE_DIR}/cmake/generate_clang_module_map.py"
                "${MODULE_MAP_DIRECTORY}"
                --module-name "${module_name}"
                --module-map "${module_map_file}"
                --vfs-map ${vfs_overlay_file}
                --exclude-files ${MODULE_MAP_EXCLUDE_FILES}
                --generated-files ${MODULE_MAP_GENERATED_FILES}
        VERBATIM
        DEPENDS "${PROJECT_SOURCE_DIR}/cmake/generate_clang_module_map.py"
    )

    add_custom_target("generate_${target_name}_module_map" DEPENDS "${module_map_file}")
    add_dependencies("${target_name}" "generate_${target_name}_module_map")

    target_compile_options(${target_name} PUBLIC "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xcc -ivfsoverlay${vfs_overlay_file}>")
endfunction()

function(invoke_generator name generator primary_source header implementation)
    cmake_parse_arguments(invoke_generator "" "" "arguments;dependencies" ${ARGN})

    add_custom_command(
        OUTPUT "${header}" "${implementation}"
        COMMAND $<TARGET_FILE:${generator}> -h "${header}.tmp" -c "${implementation}.tmp" ${invoke_generator_arguments}
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${header}.tmp" "${header}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${implementation}.tmp" "${implementation}"
        COMMAND "${CMAKE_COMMAND}" -E remove "${header}.tmp" "${implementation}.tmp"
        VERBATIM
        DEPENDS ${generator} ${invoke_generator_dependencies} "${primary_source}"
    )

    add_custom_target("generate_${name}" DEPENDS "${header}" "${implementation}")
    list(APPEND CURRENT_LIB_GENERATED "${name}")
    set(CURRENT_LIB_GENERATED ${CURRENT_LIB_GENERATED} PARENT_SCOPE)
endfunction()
