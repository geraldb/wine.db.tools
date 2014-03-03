# encoding: UTF-8

module WineDb

class CreateDb < ActiveRecord::Migration


def up


###
# wines
#
# note: key is NOT unique; require winery key
#  winery.key+wines.key => unique key  e.g.  antonbauer.gruenerveltiner

create_table :wines do |t|
  t.string  :key,     null: false   # import/export key
  t.string  :title,   null: false
  t.string  :synonyms  # comma separated list of synonyms

  t.references :winery   # optional (for now)
  t.references :variety  # optional (for now) -- todo/fix:  make required!!! why not??? possible??

  t.string  :web    # optional url link (e.g. )
  t.integer :since  # optional year (e.g. 1896)

  t.string  :txt            # source ref
  t.boolean :txt_auto, null: false, default: false     # inline? got auto-added?


  t.references :country, null: false
  t.references :region   # optional
  t.references :city     # optional
  t.references :vineyard # optional e.g. Spiegel, Gmoerk, Rosenberg, etc.

  t.timestamps
end


create_table :wineries do |t|
  t.string  :key,      null: false   # import/export key
  t.string  :title,    null: false
  t.string  :synonyms  # comma separated list of synonyms
  t.string  :address
  t.integer :since
  ## renamed to founded to since
  ## t.integer :founded  # year founded/established    - todo/fix: rename to since? 
  t.integer :closed  # optional;  year winery closed

  t.integer :area    # in ha e.g. 8 ha   # Weingarten/rebflaeche

  # use stars in .txt e.g. # ***/**/*/- => 1/2/3/4
  t.integer :grade, null: false, default: 4


  t.string  :txt            # source ref
  t.boolean :txt_auto, null: false, default: false     # inline? got auto-added?

  t.string  :web        # optional web page (e.g. www.ottakringer.at)
  t.string  :wikipedia  # optional wiki(pedia page)


  t.references :country,  null: false
  t.references :region   # optional
  t.references :city     # optional

  t.references :person  # optional for now   - winemaker/kellermeister e.g. Anton Bauer (1971) etc.

  t.timestamps
end

create_table :vintages do |t|
  t.integer    :year,  null: false
  t.references :wine,  null: false

  ## check: why decimal and not float? 
  t.decimal    :abv    # Alcohol by volume (abbreviated as ABV, abv, or alc/vol) e.g. 4.9 %

  t.timestamps  
end

create_table :grapes do |t|
  t.string   :key,      null: false   # import/export key
  t.string   :title,    null: false
  t.string   :synonyms  # comma separated list of synonyms

  t.boolean  :red,   null: false, default: false
  t.boolean  :white, null: false, default: false

  t.string   :wikipedia  # optional wiki(pedia page)

  t.timestamps
end

####
# wine families
#
#  todo/fix: allow subfamilies e.g. red wine => 1) red wine varietal, 2) red wine blended/cuvee etc.

create_table :families do |t|  # wine family e.g.  red wine/white wine/rose wine/sparkling(champagne,etc.)/desert(sweet)/fortified(port,etc.)/other etc.
  t.string     :key,      null: false   # import/export key
  t.string     :title,    null: false
  t.string     :synonyms  # comma separated list of synonyms

  t.timestamps
end

####
# wine variety
#  e.g. varietal (Gr. Veltiner) or blend/cuvee (Red Wine Cuvee) etc.
create_table :varieties do |t|
  t.string     :key,      null: false   # import/export key
  t.string     :title,    null: false
  t.string     :synonyms  # comma separated list of synonyms
  t.references :family,   null: false

  ## note: for now cuvee will NOT record blended varieties (maybe add later??)
  t.boolean    :cuvee,    null: false, default: false  # blended variety
  t.boolean    :varietal, null: false, default: false
  t.references :grape    # note: optional - only varietal has a main grape (+80%); cuvee/blended is a mix of grapes
  t.timestamps
end


################
# vineyards
#
# e.g. Spiegel, Rosenberg, Gmoerk, etc.

create_table :vineyards do |t|
  t.string     :key,      null: false   # import/export key
  t.string     :title,    null: false
  t.string     :synonyms  # comma separated list of synonyms
  t.references :city,     null: false

  t.integer :area    # in ha e.g. 8 ha   # Weingarten/rebflaeche

  t.timestamps
end

#########################
# persons (wine makers)
#  e.g. Anton Bauer (1971) etc.
#
#  note: use persons table (not makers table) and use kind/typ for (wine)maker
#
#  todo: move persons to friends.db project for (re)use;
#   see player in football.db too ???
#  and  drivers in formula1.db too and
# and  skiers in ski.db etc.

create_table :persons do |t|    # use people ? instead of persons (person/persons makes it easier?)
  t.string      :key,      null: false   # import/export key
  t.string      :name,     null: false
  t.string      :synonyms  # comma separated list of synonyms

  ## todo: add gender flag (male/female -man/lady  how?)
  t.date        :born_at     # optional date of birth (birthday)
  ## todo: add country of birth  might not be the same as nationality

  t.references  :city
  t.references  :region
  t.references  :country      ## ,  null: false

  t.references  :nationality  ## , null: false  # by default assume same as country of birth (see above)

  t.timestamps
end



end # method up

def down
  raise ActiveRecord::IrreversibleMigration
end


end # class CreateDb

end # module WineDb