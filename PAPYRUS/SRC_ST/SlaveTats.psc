scriptname SlaveTats hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

string function VERSION() global
endfunction

string function ROOT() global
endfunction

string function PREFIX() global
endfunction

int function SLOTS(string area) global
endfunction

bool function simple_add_tattoo(Actor target, string section, string name, int color = 0, bool last = true, bool silent = false, float alpha = 1.0) global
endfunction

bool function simple_remove_tattoo(Actor target, string section, string name, bool last = true, bool silent = false) global
endfunction

bool function tattoo_matches(int template, int tattoo, bool include_configurable = false) global
endfunction

bool function is_tattoo(int tattoo) global
endfunction

int function find_tattoo(int array, int template) global
endfunction

int function find_excluding_tattoo(int applied, int tattoo) global
endfunction

int function find_required_tattoo(int applied, int tattoo) global
endfunction

bool function has_required_plugin(int tattoo) global
endfunction

bool function query_available_tattoos(int template, int matches, int applied = 0, string domain = "") global
endfunction

bool function query_applied_tattoos(Actor target, int template, int matches, string except_area = "", int except_slot = -1) global
endfunction

bool function query_applied_tattoos_with_attribute(Actor target, string attrib, int matches, string except_area = "", int except_slot = -1) global
endfunction

bool function has_applied_tattoos_with_attribute(Actor target, string attrib, string except_area = "", int except_slot = -1) global
endfunction

function notify(string mesg, bool silent = false) global
endfunction

bool function remove_tattoos(Actor target, int template, bool ignore_lock = False, bool silent = False) global
endfunction

bool function _remove_tattoos(Actor target, int template, bool ignore_lock = False, bool silent = False) global
endfunction

bool function remove_tattoo_from_slot(Actor target, string area, int slot, bool ignore_lock = False, bool silent = False) global
endfunction

int function get_applied_tattoo_in_slot(Actor target, string area, int slot) global
endfunction

bool function get_applied_tattoos_by_area(Actor target, int on_body, int on_face, int on_hands, int on_feet) global
endfunction

bool function external_slots(Actor target, string area, int matches) global
endfunction

int function _available_slot(Actor target, string area) global
endfunction

bool function add_tattoo(Actor target, int tattoo, int slot = -1, bool ignore_lock = False, bool silent = False) global
endfunction

int function add_and_get_tattoo(Actor target, int tattoo, int slot = -1, bool ignore_lock = False, bool silent = False, bool try_upgrade = True) global
endfunction

int function _add_and_get_tattoo(Actor target, int tattoo, int slot = -1, bool ignore_lock = False, bool silent = False) global
endfunction

Form function get_form(int tattoo, string plugin_field, string formid_field, Form default = None) global
endfunction

bool function activate_tattoo_magic(Actor target, int tattoo, bool deactivate_first = false) global
endfunction

bool function deactivate_tattoo_magic(Actor target, int tattoo) global
endfunction

bool function deactivate_all_tattoo_magic(Actor target) global
endfunction

bool function refresh_tattoo_magic(Actor target, int template) global
endfunction

bool function upgrade_tattoos(Actor target) global
endfunction

bool function clear_overlay(Actor target, bool isFemale, string area, int slot) global
endfunction

bool function apply_overlay(Actor target, bool isFemale, string area, int slot, string path, int color, int glow, bool gloss, string bump = "", float alpha = 1.0) global
endfunction

function mark_actor(Actor target) global
endfunction

bool function synchronize_tattoos(Actor target, bool silent = false) global
endfunction

function _log_jcontainer(int jc, string indent) global
endfunction

; Dumps a tattoo to the log, with as much detail as is feasible
function log_tattoo(string msg, int tattoo) global
endfunction
