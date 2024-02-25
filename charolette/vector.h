#ifndef VECTOR_H
#define VECTOR_H

/**
 * A structure representing a point in two-dimensional space with integers.
 */
typedef struct vec2i {
    /**
     * The vector's position on the X axis.
     */
    int x;
    
    /**
     * The vector's position on the Y axis.
     */
    int y;
} vec2i;

/**
 * A structure representing a point in two-dimensional space with floating point values.
 */
typedef struct vec2f {
    /**
     * The vector's position on the X axis.
     */
    float x;
    
    /**
     * The vector's position on the Y axis.
     */
    float y;
} vec2f;

/**
 * Calculates the distance between two vectors in space, as if they were connected with a
 * single, straight line.
 *
 * @param a     The starting point or vector.
 * @param b     The final point or vector.
 * @return      The distance between the two vectors.
 */
float vec2f_distance(vec2f a, vec2f b);

/**
 * Adds two floating point vectors together by summing their individual components.
 *
 * @param lhs   The left hand side to add from.
 * @param rhs   The right hand side to add to.
 * @return      A new vector with each component summed together.
 */
vec2f vec2f_add(vec2f lhs, vec2f rhs);

/**
 * Subtracts two floating point vectors together by subtracting their individual
 * components.
 *
 * @param lhs   The left hand side to subtract from.
 * @param rhs   The right hand side to subtract to.
 * @return      A new vector with each component subtracted.
 */
vec2f vec2f_sub(vec2f lhs, vec2f rhs);

#endif
