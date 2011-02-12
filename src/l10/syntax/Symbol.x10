/* Symbols are internalized representatives of strings. They are globally 
 * unique, which means:
 * 
 *   1) Normal code should not create symbols or turn them into strings, 
 *      as this requires communication with Place.FIRST_PLACE.
 *   2) Symbols can be passed around without changing the identity of 
 *      the strings they represent.
 * */

package l10.syntax;

public struct Symbol {
}