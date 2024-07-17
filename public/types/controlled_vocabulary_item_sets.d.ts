/**
 * A term / specific value in a controlled vocabulary set.
 */
export interface ControlledVocabularyItem {
    /**
     * This should be what is passed to the actual
     */
    id: string;

    /**
     * Human-readable label for the CV Item.
     */
    label: string;

    /**
     * Machine-readable identifier for the CV.
     */
    identifier: string;

    /**
     * Ordering position within this section of the item hierarchy.
     */
    position: number;

    /**
     * Whether or not this should just be used as a grouping label and not be selectable.
     * Implies children.
     */
    unselectable: boolean;

    /**
     * An optional, internal description for the item set.
     */
    description?: string | null | undefined;

    /**
     * An optional URL to link to if present, using the `label` as the link text.
     */
    url?: string | null | undefined;
}

/**
 * Items with a depth of 2. They have no children.
 */
export interface ControlledVocabularySecondLevelItem extends ControlledVocabularyItem {
    /**
     * Final level of nesting. There are no children at this level, but the key is exposed
     * so that testing can be generic.
     */
    children?: null | undefined;
}

/**
 * Items with a depth of 1. They may have children.
 */
export interface ControlledVocabularyFirstChildItem extends ControlledVocabularyItem {
    /**
     * Second level of nesting. There are no children below this level.
     */
    children?: ControlledVocabularySecondLevelItem[] | null | undefined;
}

/**
 * Top-level items with a depth of 0. They may have children.
 */
export interface ControlledVocabularyTopLevelItem extends ControlledVocabularyItem {
    /**
     * First level of nesting.
     */
    children?: ControlledVocabularyFirstChildItem[] | null | undefined;
}

/**
 * A set of top-level items for rendering.
 */
export type ControlledVocabularyItemSet = ControlledVocabularyTopLevelItem[];