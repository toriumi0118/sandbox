require 'active_record'

class Office < ActiveRecord::Base
  self.table_name = 'office'
  self.primary_key = 'office_id'
end

class Kyotaku < ActiveRecord::Base
  self.table_name = 'kyotaku'
  self.primary_key = 'office_id'
end

class RelHelpLevel < ActiveRecord::Base
  self.table_name = 'rel_help_level'
end

class Vacancy < ActiveRecord::Base
  self.table_name = 'vacancy'
end

class RelExtra < ActiveRecord::Base
  self.table_name = 'rel_extra'
end

class RelAddFee < ActiveRecord::Base
  self.table_name = 'rel_add_fee'
end

class RelAddFeeWorker < ActiveRecord::Base
  self.table_name = 'rel_add_fee_worker'
end

class OfficePrice < ActiveRecord::Base
  self.table_name = 'office_price'
  self.primary_key = 'office_id'
end

class OfficeLicence < ActiveRecord::Base
  self.table_name = 'office_licence'
  self.primary_key = 'office_id'
end

class AttrBusinessKind < ActiveRecord::Base
  self.table_name = 'attr_business_kind'
end

class RelBusinessKind < ActiveRecord::Base
  self.table_name = 'rel_business_kind'
end

class OfficeContract < ActiveRecord::Base
  self.table_name = 'office_contract'
  self.primary_key = 'office_id'
end

class BusinessTime < ActiveRecord::Base
  self.table_name = 'business_time'
end

class OfficeHistory < ActiveRecord::Base
  self.table_name = 'office_history'
  self.primary_key = 'id'
end

class KyotakuHistory < ActiveRecord::Base
  self.table_name = 'kyotaku_history'
  self.primary_key = 'id'
end

class RelKyotakuTellEmergency < ActiveRecord::Base
  self.table_name = 'rel_kyotaku_tell_emergency'
end

class AttrKyotakuServiceArea < ActiveRecord::Base
  self.table_name = 'attr_kyotaku_service_area'
end

class RelKyotakuServiceArea < ActiveRecord::Base
  self.table_name = 'rel_kyotaku_service_area'
end

class KyotakuBusinessTime < ActiveRecord::Base
  self.table_name = 'kyotaku_business_time'
end

class KyotakuLicense < ActiveRecord::Base
  self.table_name = 'kyotaku_license'
end

class RelKyotakuCareAddFeeOther < ActiveRecord::Base
  self.table_name = 'rel_kyotaku_care_add_fee_other'
end

class RelKyotakuCareAddFeeService < ActiveRecord::Base
  self.table_name = 'rel_kyotaku_care_add_fee_service'
end

class RelKyotakuCareAddFeeStaff < ActiveRecord::Base
  self.table_name = 'rel_kyotaku_care_add_fee_staff'
end
