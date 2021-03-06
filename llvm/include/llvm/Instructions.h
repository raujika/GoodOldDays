//===-- llvm/Instructions.h - Instruction subclass definitions --*- C++ -*-===//
// 
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
// 
//===----------------------------------------------------------------------===//
//
// This file exposes the class definitions of all of the subclasses of the
// Instruction class.  This is meant to be an easy way to get access to all
// instruction subclasses.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_INSTRUCTIONS_H
#define LLVM_INSTRUCTIONS_H

#include "llvm/iTerminators.h"   // Terminator instructions
#include "llvm/iPHINode.h"       // The PHI node instruction
#include "llvm/iOperators.h"     // Binary operator instructions
#include "llvm/iMemory.h"        // Memory related instructions
#include "llvm/iOther.h"         // Everything else

#endif
