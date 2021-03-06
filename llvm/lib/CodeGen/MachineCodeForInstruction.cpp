//===-- MachineCodeForInstruction.cpp -------------------------------------===//
// 
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
// 
//===----------------------------------------------------------------------===//
//
// Representation of the sequence of machine instructions created for a single
// VM instruction.  Additionally records information about hidden and implicit
// values used by the machine instructions: about hidden values used by the
// machine instructions:
// 
// "Temporary values" are intermediate values used in the machine instruction
// sequence, but not in the VM instruction Note that such values should be
// treated as pure SSA values with no interpretation of their operands (i.e., as
// a TmpInstruction object which actually represents such a value).
// 
// (2) "Implicit uses" are values used in the VM instruction but not in the
//     machine instruction sequence
// 
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/MachineCodeForInstruction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrAnnot.h"
#include "llvm/CodeGen/InstrSelection.h"

AnnotationID MCFI_AID(
             AnnotationManager::getID("CodeGen::MachineCodeForInstruction"));

static Annotation *CreateMCFI(AnnotationID AID, const Annotable *, void *) {
  assert(AID == MCFI_AID);
  return new MachineCodeForInstruction();  // Invoke constructor!
}

// Register the annotation with the annotation factory
static struct MCFIInitializer {
  MCFIInitializer() {
    AnnotationManager::registerAnnotationFactory(MCFI_AID, &CreateMCFI);
  }
} RegisterCreateMCFI;


void
MachineCodeForInstruction::dropAllReferences()
{
  for (unsigned i=0, N=tempVec.size(); i < N; i++)
    cast<TmpInstruction>(tempVec[i])->dropAllReferences();
}


MachineCodeForInstruction::~MachineCodeForInstruction()
{
  // Let go of all uses in temp. instructions
  dropAllReferences();
  
  // Free the Value objects created to hold intermediate values
  for (unsigned i=0, N=tempVec.size(); i < N; i++)
    delete tempVec[i];
  
  // Free the MachineInstr objects allocated, if any.
  for (unsigned i=0, N = size(); i < N; i++)
    delete (*this)[i];

  // Free the CallArgsDescriptor if it exists.
  if (callArgsDesc)
    delete callArgsDesc;
}
