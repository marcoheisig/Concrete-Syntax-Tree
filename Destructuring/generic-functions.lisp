(cl:in-package #:concrete-syntax-tree)

;;;; Generally speaking, these functions collectively take a macro
;;;; lambda list and a BODY form, and wrap the body form in a bunch
;;;; of LET bindings, for the purpose of creating a lambda expression
;;;; corresponding to a macro function.

;;;; Every function defined here wraps a BODY form in some LET
;;;; bindings.  These LET bindings are determined by the parameters of
;;;; a lambda list.  Each function handles a different part of the
;;;; lambda list.  CLIENT is some object representing the client.  It
;;;; is used among other things to determine which condition class to
;;;; use when a a condition needs to be signaled.  ARGUMENT-VARIABLE
;;;; is a symbol that, when the resulting macro function is executed
;;;; on some compound form corresponding to a macro call, will hold
;;;; the remaining part of the arguments of that macro call yet to be
;;;; processed.

;;;; Some functions have an argument called TAIL-VARIABLE, which is
;;;; also a symbol that is going to be used in subsequent
;;;; destructuring functions for the same purpose as
;;;; ARGUMENT-VARIABLE.  Such a function is responsible for creating
;;;; an innermost LET form that binds the TAIL-VARIABLE symbol to the
;;;; part of the argument list that remains after the function has
;;;; done its processing.  Some functions do not need such a variable,
;;;; because they do not consume any arguments, so the remaining
;;;; argument list is the same as the initial one.

;;; Given an entire lambda list, which can be a macro lambda list or a
;;; destructuring lambda list, Wrap BODY in a bunch of nested LET
;;; bindings according to the parameters of the lambda list.
(defgeneric destructure-lambda-list
    (client lambda-list argument-variable tail-variable body))

;;; Wrap BODY in a LET form corresponding to a single &AUX parameter.
;;; Since &AUX parameters are independent of the macro-call arguments,
;;; there is no need for an ARGUMENT-VARIABLE.  The &AUX parameter
;;; itself provides all the information required to determine the LET
;;; binding.
(defgeneric destructure-aux-parameter (client aux-parameter body))

;;; Wrap BODY in nested LET forms, each corresponding to a single &AUX
;;; parameter in the list of &AUX parameters PARAMETERS.  Since &AUX
;;; parameters are independent of the macro-call argument, there is no
;;; need for an ARGUMENT-VARIABLE.  Each &AUX parameter in PARAMETERS
;;; itself provides all the information required to determine the LET
;;; binding.
(defgeneric destructure-aux-parameters (client parameters body))

;;; Wrap BODY in a LET form corresponding to a single &KEY parameter.
(defgeneric destructure-key-parameter
    (client key-parameter argument-variable body))

;;; Wrap BODY in nested LET forms, each corresponding to a single &KEY
;;; parameter in a list of such &KEY parameters.  Since &KEY
;;; parameters do not consume any arguments, the list of arguments is
;;; the same before and after the &KEY parameters have been processed.
;;; As a consequence, we do not need a TAIL-VARIABLE for &KEY
;;; parameters.
(defgeneric destructure-key-parameters
    (client parameters argument-variable body))

;;; Wrap body in a LET form corresponding to a &REST parameter.  Since
;;; &REST parameters do not consume any arguments, the list of
;;; arguments is the same before and after the &REST parameter has
;;; been processed.  As a consequence, we do not need a TAIL-VARIABLE
;;; for &REST parameters.
(defgeneric destructure-rest-parameter
    (client parameter argument-variable body))

;;; Wrap BODY in a LET form corresponding to a single &OPTIONAL
;;; parameter.
(defgeneric destructure-optional-parameter
    (client optional-parameter argument-variable body))

;;; Wrap BODY in nested LET forms, each corresponding to a single
;;; &OPTIONAL parameter in a list of such &OPTIONAL parameters.  Since
;;; every &OPTIONAL parameter DOES consume an argument, this function
;;; does take a TAIL-VARIABLE argument as described above.
(defgeneric destructure-optional-parameters
    (client parameters argument-variable tail-variable body))

;;; Wrap BODY in one or more LET forms corresponding to a single
;;; required parameter, depending on whether the required parameter is
;;; a simple variable or a destructuring lambda list.
(defgeneric destructure-required-parameter
    (client parameter argument-variable body))

;;; Wrap BODY in nested LET forms, corresponding to the list of
;;; required parameters in the list of required parameters PARAMETERS.
;;; Since every required parameter DOES consume an argument, this
;;; function does take a TAIL-VARIABLE argument as described above.
(defgeneric destructure-required-parameters
    (client parameters argument-variable tail-variable body))

;;; Wrap BODY in nested LET forms, corresponding to the parameters in
;;; PARAMETER-GROUP.
(defgeneric destructure-parameter-group
    (client parameter-group argument-variable tail-variable body))

;;; Wrap BODY in nested LET forms, corresponding to the parameters in
;;; the list of parameter groups PARAMETER-GROUPS.
(defgeneric destructure-parameter-groups
    (client parameter-groups argument-variable tail-variable body))
