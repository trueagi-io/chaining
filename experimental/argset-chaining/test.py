#from hyperon.ext import register_atoms

def plus(atom1, atom2):
    return [atom1 + atom2]

#    from hyperon import ValueAtom
#    sum = atom1.get_object().value + atom2.get_object().value
#    return [ValueAtom(sum, 'Number')]

#from hyperon import OperationAtom
#plus_atom = OperationAtom("plus", plus,
#    ['Number', 'Number', 'Number'], unwrap=False)

#@register_atoms
#def my_atoms():
#    return {"plus": plus_atom}
