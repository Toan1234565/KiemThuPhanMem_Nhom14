using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace GOATBOOKING.Models;

public partial class Homestay
{
    [Key]
    public long HomestayId { get; set; }
    [Required(ErrorMessage = "Tên homestay là bắt buộc")]
    public string Name { get; set; } = null!;
    [Required(ErrorMessage = "Mô tả homestay là bắt buộc")]
    public string Description { get; set; }
    [Required(ErrorMessage = "Phường/xã là bắt buộc")]
    public string Ward { get; set; }
    [Required(ErrorMessage = "Quận/Huyện là bắt buộc")]
    public string District { get; set; }

    [Required(ErrorMessage = "Tỉnh/Thành phố là bắt buộc")]
    public string Province { get; set; }

    public long CreatedAt { get; set; }

    public long UpdatedAt { get; set; }
    
    public long UserId { get; set; }

    public virtual ICollection<Photo> Photos { get; set; } = new List<Photo>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<Room> Rooms { get; set; } = new List<Room>();

    public virtual ICollection<ServicesAdvantage> ServicesAdvantages { get; set; } = new List<ServicesAdvantage>();

    public virtual User? User { get; set; }

}
